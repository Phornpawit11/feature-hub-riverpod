# Implementation Plan — todos_riverpod Frontend

> **หมายเหตุ:** ยกเว้น Fix #1 (HTTP → HTTPS) เนื่องจากอยู่ในช่วง Development

---

## 🔁 QA Workflow — รันทุกครั้งก่อน commit

```bash
# 1. Static analysis — ต้องไม่มี error/warning เลย
flutter analyze

# 2. Unit + Widget tests ทั้งหมด
flutter test

# 3. รัน test เฉพาะ group ที่แก้ไขล่าสุด (เร็วกว่า)
flutter test test/feature/todos/usecase/
flutter test test/feature/auth/usecase/
flutter test test/core/network/

# 4. แสดง coverage (ต้องติดตั้ง lcov ก่อน)
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

> **เป้าหมาย:** `flutter analyze` → 0 issues, `flutter test` → all passed ทุกครั้ง  
> **ห้าม commit** ถ้ายังมี analyze error หรือ test fail

---

## 📊 สถานะ Test Suite ปัจจุบัน

```
test/
├── feature/
│   ├── todos/
│   │   ├── data/
│   │   │   ├── todo_local_datasource_test.dart       ✅ ครอบคลุมดี
│   │   │   ├── todo_repository_impl_test.dart        ✅ ครอบคลุมดี
│   │   │   ├── date_tag_local_datasource_test.dart   ✅ ครอบคลุมดี
│   │   │   └── date_tag_repository_impl_test.dart    ✅ ครอบคลุมดี
│   │   ├── domain/
│   │   │   └── todo_model_test.dart                  ✅ ครอบคลุมดี
│   │   ├── usecase/
│   │   │   ├── todo_usecase_test.dart                ⚠️  ขาด error scenario
│   │   │   └── date_tag_usecase_test.dart            ✅ ครอบคลุมดี
│   │   └── presentation/
│   │       ├── todo_tile_test.dart                   ⚠️  ขาด delete confirmation
│   │       ├── todo_editor_fields_test.dart          ✅ ครอบคลุมดี
│   │       └── todo_date_tag_widget_test.dart        ✅ ครอบคลุมดี (1193 บรรทัด)
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_remote_datasource_test.dart      ✅ ครอบคลุมดี
│   │   ├── presentation/
│   │   │   └── login_screen_test.dart               ⚠️  มีแค่ 21 บรรทัด ขาด validation edge cases
│   │   └── usecase/
│   │       └── auth_usecase_test.dart               ⚠️  ขาด google signOut + duplicate API call
├── core/
│   ├── network/
│   │   └── api_client_provider_test.dart            ✅ ครอบคลุมดี (concurrent refresh)
│   └── widgets/
│       └── app_drawer_test.dart                     ✅ ครอบคลุมดี
└── app/
    └── widget_test.dart                             ❌  placeholder เปล่า
```

---

## 🗺️ Roadmap Overview

```
Batch 1 ── GoRouter fix + AsyncValue.guard           (Critical,     ~2h)
    │
Batch 2 ── UUID + Google logout + No double submit   (High,         ~2h)
    │
Batch 3 ── Email validation + Delete confirm + Retry + ref.read  (Medium, ~2h)
    │
Batch 4 ── Calendar UX + Remove duplicate API call   (Enhancement,  ~1h)
    │
Future ─── Env config, i18n, Pagination, Lifecycle
```

---

## 🔴 Batch 1 — Critical

### Fix #2 — GoRouter ใช้ `refreshListenable` แทน `ref.watch`

**ปัญหา:** `ref.watch(authUsecaseProvider)` ทำให้ GoRouter ถูกสร้างใหม่ทุกครั้งที่ AuthState เปลี่ยน (อย่างน้อย 4 ครั้งต่อ login flow) ส่งผลให้ navigation stack หาย และอาจเกิด memory leak

**ไฟล์:** `lib/src/router/app_router.dart`

```dart
// เพิ่ม class นี้ด้านบนของไฟล์
class _AuthStateListenable extends ValueNotifier<AuthState> {
  _AuthStateListenable(super.value);
  void update(AuthState state) => value = state;
}

// แทนที่ goRouterProvider ทั้งหมด
final goRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref.read(authUsecaseProvider));

  // sync listenable เมื่อ auth state เปลี่ยน
  ref.listen(authUsecaseProvider, (_, next) => listenable.update(next));

  final router = GoRouter(
    initialLocation: SGRoute.login.route,
    refreshListenable: listenable,         // ← trigger redirect ใหม่ ไม่สร้าง GoRouter ใหม่
    routes: <GoRoute>[
      GoRoute(
        path: SGRoute.login.route,
        name: SGRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: SGRoute.landing.route,
        name: SGRoute.landing.name,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: SGRoute.todo.route,
        name: SGRoute.todo.name,
        builder: (context, state) => const TodoScreen(),
      ),
    ],
    redirect: (context, state) {
      final auth = listenable.value;
      final location = state.matchedLocation;
      final isLoginRoute = location == SGRoute.login.route;
      final isTodoRoute = location == SGRoute.todo.route;

      if (!auth.isAuthenticated && isTodoRoute) {
        return SGRoute.login.route;
      }
      if (auth.isAuthenticated && isLoginRoute) {
        return SGRoute.todo.route;
      }
      return null;
    },
  );

  ref.onDispose(listenable.dispose);
  return router;
});
```

**Tests:**

ไฟล์ใหม่: `test/router/app_router_test.dart`

```
ต้องเพิ่ม test:
✅ redirect ไป /login เมื่อ unauthenticated และเข้า /todo
✅ redirect ไป /todo เมื่อ authenticated และเข้า /login
✅ ไม่ redirect เมื่อ unauthenticated และอยู่ที่ /login แล้ว
✅ ไม่ redirect เมื่อ authenticated และอยู่ที่ /todo แล้ว
✅ goRouterProvider คืน instance เดิม เมื่อ auth state เปลี่ยน
  (verify ด้วย identical() — สำคัญที่สุด ป้องกัน regression)
```

```bash
flutter test test/router/
```

---

### Fix #3 — `_refreshTodos()` ใช้ `AsyncValue.guard`

**ปัญหา:** ถ้า `getTodos()` โยน exception, state จะค้างกับข้อมูลเก่าโดยไม่แจ้ง UI และ `toggleTodo`, `deleteTodo`, `addTodo`, `editTodo` ทุกอันใช้ฟังก์ชันนี้

**ไฟล์:** `lib/src/feature/todos/usecase/todo.usecase.dart`

```dart
// BEFORE
Future<void> _refreshTodos() async {
  state = AsyncData<List<Todo>>(await _todoRepository.getTodos());
}

// AFTER
Future<void> _refreshTodos() async {
  state = await AsyncValue.guard(() => _todoRepository.getTodos());
}
```

**Tests:**

ไฟล์: `test/feature/todos/usecase/todo_usecase_test.dart` — **เพิ่ม test group ใหม่**

```
ต้องเพิ่ม test (ใน group 'TodoUsecase error handling'):
✅ state เป็น AsyncError เมื่อ getTodos() throw หลังจาก addTodo
✅ state เป็น AsyncError เมื่อ getTodos() throw หลังจาก toggleTodo
✅ state เป็น AsyncError เมื่อ getTodos() throw หลังจาก deleteTodo
✅ state กลับมา build ได้ใหม่ หลัง ref.invalidate (recovery test)
```

เพิ่ม `_FakeTodoRepository` ที่มี `throwOnNextGet` flag:
```dart
class _FakeTodoRepository implements TodoRepository {
  bool throwOnNextGet = false;   // ← เพิ่มตรงนี้

  @override
  Future<List<Todo>> getTodos() async {
    getTodosCallCount++;
    if (throwOnNextGet) {
      throwOnNextGet = false;
      throw Exception('Storage error');
    }
    return List.unmodifiable(_todos);
  }
  // ... ส่วนที่เหลือเหมือนเดิม
}
```

```bash
flutter test test/feature/todos/usecase/todo_usecase_test.dart
```

---

## 🟠 Batch 2 — High Priority

### Fix #4 — Todo ID ใช้ UUID แทน Timestamp

**ปัญหา:** `DateTime.now().microsecondsSinceEpoch.toString()` อาจชนกันถ้า add เร็วๆ และคาดเดาได้

**ไฟล์:** `pubspec.yaml`, `lib/src/feature/todos/usecase/todo.usecase.dart`, `lib/src/feature/todos/usecase/date_tag_usecase.dart`

```yaml
# pubspec.yaml — เพิ่ม dependency
dependencies:
  uuid: ^4.0.0
```

```dart
// todo.usecase.dart — เพิ่ม import
import 'package:uuid/uuid.dart';

// addTodo() — เปลี่ยน id
final newTodo = Todo(
  id: const Uuid().v4(),   // แทน DateTime.now().microsecondsSinceEpoch.toString()
  title: trimmedText,
  // ...
);
```

```dart
// date_tag_usecase.dart — ทุกจุดที่ใช้ timestamp เป็น id
import 'package:uuid/uuid.dart';

id: const Uuid().v4(),
```

**Tests:**

ไฟล์: `test/feature/todos/usecase/todo_usecase_test.dart` — **เพิ่ม test**

```
ต้องเพิ่ม test:
✅ addTodo หลายครั้งติดกัน → ID ทุกอันไม่ซ้ำกัน
✅ ID ที่ได้ match UUID v4 format (RegExp)
✅ addTodo 2 ครั้งพร้อมกัน (Future.wait) → ID ต่างกัน
```

```dart
// ตัวอย่าง test
test('generated IDs are unique across rapid successive adds', () async {
  await container.read(todoUsecaseProvider.future);
  await Future.wait([
    container.read(todoUsecaseProvider.notifier).addTodo(title: 'Task A'),
    container.read(todoUsecaseProvider.notifier).addTodo(title: 'Task B'),
  ]);
  final todos = await container.read(todoUsecaseProvider.future);
  final ids = todos.map((t) => t.id).toList();
  expect(ids.toSet().length, ids.length); // ไม่มี duplicate
});

test('generated ID matches UUID v4 format', () async {
  await container.read(todoUsecaseProvider.future);
  await container.read(todoUsecaseProvider.notifier).addTodo(title: 'UUID test');
  final todos = await container.read(todoUsecaseProvider.future);
  final newId = todos.last.id;
  final uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );
  expect(uuidRegex.hasMatch(newId), isTrue);
});
```

```bash
flutter test test/feature/todos/usecase/todo_usecase_test.dart
```

---

### Fix #5 — Sign Out เรียก Google Sign Out ด้วย

**ปัญหา:** Google session ยังค้างอยู่หลัง logout ทำให้ครั้งถัดไป Google auto-login โดยไม่ถาม ซึ่งเป็นปัญหาบนอุปกรณ์ที่ใช้ร่วมกัน

**ไฟล์:** `lib/src/feature/auth/data/google_sign_in_adapter.dart`, `lib/src/feature/auth/usecase/auth_usecase.dart`

```dart
// google_sign_in_adapter.dart — เพิ่ม method
Future<void> signOut() async {
  await _ensureInitialized();
  try {
    await _googleSignIn.signOut();
  } catch (_) {} // best-effort เท่านั้น ไม่ throw
}
```

```dart
// auth_usecase.dart — signOut() เพิ่มบรรทัดนี้ก่อน logic เดิม
Future<void> signOut() async {
  // เพิ่มส่วนนี้
  try {
    await ref.read(googleSignInAdapterProvider).signOut();
  } catch (_) {}

  // ส่วนที่เหลือเหมือนเดิม
  final refreshToken = await _storage.readRefreshToken();
  if (refreshToken != null && refreshToken.isNotEmpty) {
    try {
      await _repository.logout(refreshToken: refreshToken);
    } catch (_) {}
  }
  await _storage.clearTokens();
  state = AuthState.unauthenticated;
}
```

**Tests:**

ไฟล์: `test/feature/auth/usecase/auth_usecase_test.dart` — **แก้ไข test เดิม + เพิ่มใหม่**

```
ต้องเพิ่ม _FakeGoogleSignInAdapter ใน test file:
class _FakeGoogleSignInAdapter extends GoogleSignInAdapter {
  int signOutCallCount = 0;
  bool throwOnSignOut = false;

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    if (throwOnSignOut) throw Exception('Google sign out failed');
  }
  // ... implement ส่วนอื่นๆ ที่ required
}
```

```
ต้องเพิ่ม test:
✅ signOut เรียก googleSignInAdapter.signOut() หนึ่งครั้ง
✅ signOut สำเร็จแม้ googleSignInAdapter.signOut() throw (best-effort)
✅ signOut ยังคง clearTokens และเปลี่ยน state เป็น unauthenticated เสมอ

ต้องแก้ test เดิม 'signOut calls logout best-effort...':
- เพิ่ม override isMobileGoogleSignInSupportedProvider + googleSignInAdapterProvider
- verify googleSignOutCallCount == 1
```

```bash
flutter test test/feature/auth/usecase/auth_usecase_test.dart
```

---

### Fix #6 — ป้องกัน Double Submit ใน `submitTodo`

**ปัญหา:** ไม่มี loading state ระหว่าง await ทำให้ user กด "Add task" ซ้ำได้ก่อน Hive เสร็จ

**ไฟล์:** `lib/src/feature/todos/presentation/todo.screen.dart`

```dart
// เพิ่ม state ใน build()
final isSubmittingTodo = useState(false);

// แก้ submitTodo()
Future<void> submitTodo() async {
  final title = textEditingController.text.trim();
  if (title.isEmpty || isSubmittingTodo.value) return; // ← guard double-submit

  isSubmittingTodo.value = true;
  try {
    await ref.read(todoUsecaseProvider.notifier).addTodo(
      title: title,
      priority: selectedPriority.value,
      dueDate: selectedDueDate.value,
      colorValue: selectedColorValue.value,
    );
    resetComposer();
    isComposerExpanded.value = false;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } finally {
    isSubmittingTodo.value = false; // ← reset เสมอ ไม่ว่า success หรือ error
  }
}

// ใน TodoComposerCard — ป้องกันกดซ้ำ
TodoComposerCard(
  // ... props เดิม ...
  onSubmit: isSubmittingTodo.value ? null : submitTodo,
),
```

**Tests:**

ไฟล์ใหม่: `test/feature/todos/presentation/todo_screen_test.dart`

```
ต้องเพิ่ม test:
✅ กด submit ขณะ isSubmitting == true → addTodo ถูกเรียกแค่ครั้งเดียว
✅ submit ด้วย title ว่าง → addTodo ไม่ถูกเรียก
✅ หลัง submit สำเร็จ → text field ถูก clear
✅ หลัง submit สำเร็จ → SnackBar 'Task added' ปรากฏ

hint: ใช้ Completer เพื่อ simulate async delay แล้วกดซ้ำระหว่างรอ
```

```bash
flutter test test/feature/todos/presentation/todo_screen_test.dart
```

---

## 🟡 Batch 3 — Medium: UX & Correctness

### Fix #7 — Email Validation ที่ถูกต้อง

**ปัญหา:** `!email.contains('@')` ผ่าน input เช่น `a@` หรือ `@domain` ได้

**ไฟล์:** `pubspec.yaml`, `lib/src/feature/auth/presentation/login.screen.dart`

```yaml
# pubspec.yaml
dependencies:
  email_validator: ^3.0.0
```

```dart
// login.screen.dart
import 'package:email_validator/email_validator.dart';

// BEFORE
if (email.isEmpty || !email.contains('@')) {
  emailError.value = 'Enter a valid email address.';
  hasError = true;
}

// AFTER
if (email.isEmpty || !EmailValidator.validate(email)) {
  emailError.value = 'Enter a valid email address.';
  hasError = true;
}
```

**Tests:**

ไฟล์: `test/feature/auth/presentation/login_screen_test.dart` — **ขยายจาก 21 บรรทัด**

```
ต้องเพิ่ม test (ปัจจุบันมีน้อยมาก):
✅ submit ด้วย email ว่าง → แสดง error 'Enter a valid email address.'
✅ submit ด้วย email แค่มี @ เช่น 'a@' → แสดง error
✅ submit ด้วย '@domain.com' → แสดง error
✅ submit ด้วย 'notanemail' → แสดง error
✅ submit ด้วย 'user@domain.com' → ไม่แสดง email error
✅ submit ด้วย password ว่าง → แสดง error 'Enter your password.'
✅ error หายเมื่อ user พิมพ์ใน email field
✅ ปุ่ม Sign in disable เมื่อ isSubmitting
✅ แสดง errorMessage จาก authState
```

```bash
flutter test test/feature/auth/presentation/login_screen_test.dart
```

---

### Fix #8 — Confirmation Dialog ก่อนลบ Todo

**ปัญหา:** ลบทันทีโดยไม่ถาม ทำให้ลบผิดพลาดง่าย

**ไฟล์:** `lib/src/feature/todos/presentation/todo.screen.dart`

```dart
Future<void> deleteTodo(String todoId) async {
  // เพิ่ม confirmation ก่อน
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete task?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirmed != true) return; // ← ยกเลิกถ้า user กด Cancel

  await ref.read(todoUsecaseProvider.notifier).deleteTodo(todoId);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

**Tests:**

ไฟล์: `test/feature/todos/presentation/todo_tile_test.dart` — **เพิ่ม test** (และ `todo_screen_test.dart`)

```
ต้องเพิ่ม test:
✅ กด delete → dialog 'Delete task?' ปรากฏ
✅ กด 'Cancel' ใน dialog → todo ไม่ถูกลบ, onDelete ไม่ถูกเรียก
✅ กด 'Delete' ใน dialog → onDelete ถูกเรียกพร้อม todoId ที่ถูกต้อง
✅ หลังลบสำเร็จ → SnackBar 'Task deleted' ปรากฏ
✅ ปิด dialog ด้วย back button → todo ไม่ถูกลบ
```

```bash
flutter test test/feature/todos/presentation/todo_tile_test.dart
```

---

### Fix #9 — Error State มีปุ่ม Retry

**ปัญหา:** ถ้า load todos ผิดพลาด user ไม่สามารถ retry ได้ ต้องปิด-เปิด app

**ไฟล์:** `lib/src/feature/todos/presentation/todo.screen.dart`

```dart
// แทนที่ error builder ทั้ง 2 จุด (todoListAsync และ dateTagAsync)

// สำหรับ todoListAsync
error: (err, stack) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 40),
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Something went wrong'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => ref.invalidate(todoUsecaseProvider),
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    ),
  ),
),

// สำหรับ dateTagAsync
error: (err, stack) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 40),
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Something went wrong'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => ref.invalidate(dateTagUsecaseProvider),
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    ),
  ),
),
```

**Tests:**

ไฟล์: `test/feature/todos/presentation/todo_screen_test.dart` — **เพิ่ม test**

```
ต้องเพิ่ม test:
✅ เมื่อ todoUsecaseProvider error → แสดงข้อความ 'Something went wrong'
✅ เมื่อ todoUsecaseProvider error → แสดงปุ่ม 'Retry'
✅ กด 'Retry' → todoUsecaseProvider ถูก rebuild (getTodos ถูกเรียกอีกครั้ง)
```

```bash
flutter test test/feature/todos/presentation/todo_screen_test.dart
```

---

### Fix #12 — `ref.watch` → `ref.read` ใน Repository

**ปัญหา:** `ref.watch()` ควรใช้ใน `build()` เท่านั้น การใช้นอก build ทำให้ dependency tracking ไม่ถูกต้อง

**ไฟล์:** `lib/src/feature/todos/data/repository/todo_repository_impl.dart`

```dart
// BEFORE
TodoLocalDatasource get _datasourceProvider =>
    ref.watch(todoLocalDatasourceProvider.notifier);

// AFTER
TodoLocalDatasource get _datasourceProvider =>
    ref.read(todoLocalDatasourceProvider.notifier);
```

**Tests:**

```
ไม่ต้องเพิ่ม test ใหม่ — แต่ต้องตรวจสอบว่า test เดิมยังผ่านทั้งหมด:
✅ flutter test test/feature/todos/data/todo_repository_impl_test.dart
✅ flutter analyze → ต้องไม่มี warning เรื่อง ref.watch นอก build
```

```bash
flutter analyze lib/src/feature/todos/data/repository/
flutter test test/feature/todos/data/todo_repository_impl_test.dart
```

---

## 🔵 Batch 4 — Enhancement

### Fix #10 — `changeFocusedMonth` รักษา Selected Day

**ปัญหา:** เปลี่ยนเดือนแล้ว selected date กระโดดไปวันที่ 1 ของเดือนใหม่เสมอ

**ไฟล์:** `lib/src/feature/todos/presentation/todo.screen.dart`

```dart
void changeFocusedMonth(DateTime month) {
  focusedMonth.value = DateTime(month.year, month.month);

  final current = selectedCalendarDate.value;

  // ถ้าอยู่เดือนเดิมแล้ว ไม่ต้องเปลี่ยน selected date
  if (current.year == month.year && current.month == month.month) return;

  // ลองคง day เดิม ถ้าไม่มีในเดือนนั้น (เช่น 31 ใน Feb) ให้ใช้วันสุดท้าย
  final lastDayOfMonth = DateTime(month.year, month.month + 1, 0).day;
  final targetDay = current.day.clamp(1, lastDayOfMonth);
  selectedCalendarDate.value = DateTime(month.year, month.month, targetDay);
}
```

**Tests:**

ไฟล์: `test/feature/todos/presentation/todo_date_tag_widget_test.dart` — **เพิ่ม test** (ไฟล์นี้ใหญ่อยู่แล้ว 1193 บรรทัด)

```
ต้องเพิ่ม test:
✅ เปลี่ยนจากเดือน Jan วันที่ 15 → Feb: selectedDate เป็น Feb 15 (ไม่ใช่ Feb 1)
✅ เปลี่ยนจากเดือน Jan วันที่ 31 → Feb: selectedDate เป็น Feb 28 (หรือ 29 ถ้า leap year)
✅ เปลี่ยนเดือนเดิมซ้ำ: selectedDate ไม่เปลี่ยน
✅ เปลี่ยนจาก Mar วันที่ 31 → Apr: selectedDate เป็น Apr 30
```

```bash
flutter test test/feature/todos/presentation/todo_date_tag_widget_test.dart
```

---

### Fix #11 — ลด API Call ซ้ำใน `restoreSession`

**ปัญหา:** หลัง refresh token สำเร็จ ยังเรียก `getCurrentUser()` อีกครั้งทั้งที่ session มี user อยู่แล้ว

**ไฟล์:** `lib/src/feature/auth/usecase/auth_usecase.dart`

> ⚠️ **ตรวจสอบก่อน:** Backend ต้องส่ง `user` object กลับมาใน `/auth/refresh` response ด้วย

```dart
// ในส่วน refresh token flow — แทนที่ 2 บรรทัดนี้
// BEFORE
final session = await _repository.refreshSession(refreshToken: refreshToken);
await _storage.writeTokens(...);
final user = await _repository.getCurrentUser(session.accessToken); // ← ลบ
state = AuthState(status: AuthStatus.authenticated, user: user);

// AFTER
final session = await _repository.refreshSession(refreshToken: refreshToken);
await _storage.writeTokens(...);
state = AuthState(status: AuthStatus.authenticated, user: session.user); // ← ใช้ user จาก session
```

**Tests:**

ไฟล์: `test/feature/auth/usecase/auth_usecase_test.dart` — **แก้ไข test เดิม**

```
ต้องแก้ test 'restoreSession refreshes tokens when access token is invalid':
✅ ยืนยันว่า fakeRepository.lastCurrentUserToken เป็น null หลังจาก refresh
   (getCurrentUser ต้องไม่ถูกเรียกเลยใน path นี้)

ต้องเพิ่ม test:
✅ restoreSession ใช้ user จาก refreshSession response โดยตรง
✅ getCurrentUser ถูกเรียกแค่ครั้งเดียว (ตอน access token ยังใช้งานได้)
```

```bash
flutter test test/feature/auth/usecase/auth_usecase_test.dart
```

---

## ⚪ Future Sprint (Low Priority)

| # | งาน | ความซับซ้อน | รายละเอียด |
|---|---|---|---|
| 13 | Production URL / Env Config | M | ใช้ `--dart-define=API_BASE_URL=...` + build flavors สำหรับ dev/staging/prod |
| 14 | i18n / Localization | L | `flutter_localizations` + `.arb` files, รองรับ EN/TH |
| 15 | Pagination สำหรับ Todo List | L | Cursor-based pagination ใน Hive, lazy-load เมื่อ scroll ถึงท้าย |
| 16 | แก้ `Future.microtask` Pattern | M | ย้าย session restore ไปใน `main()` หรือใช้ `WidgetsBindingObserver` |

---

## 🧪 Test ที่ต้องเพิ่มทั้งหมด (สรุป)

| ไฟล์ | สถานะ | สิ่งที่ต้องทำ |
|---|---|---|
| `test/router/app_router_test.dart` | ❌ ยังไม่มี | สร้างใหม่ — test redirect + instance identity |
| `test/feature/todos/usecase/todo_usecase_test.dart` | ⚠️ มีบางส่วน | เพิ่ม error handling + UUID + concurrent add |
| `test/feature/auth/usecase/auth_usecase_test.dart` | ⚠️ มีบางส่วน | เพิ่ม Google signOut + duplicate API call |
| `test/feature/auth/presentation/login_screen_test.dart` | ⚠️ แค่ 21 บรรทัด | ขยาย validation edge cases ทั้งหมด |
| `test/feature/todos/presentation/todo_screen_test.dart` | ❌ ยังไม่มี | สร้างใหม่ — double submit + retry + delete confirm |
| `test/feature/todos/presentation/todo_tile_test.dart` | ⚠️ มีบางส่วน | เพิ่ม delete confirmation dialog |
| `test/feature/todos/presentation/todo_date_tag_widget_test.dart` | ✅ ดีอยู่แล้ว | เพิ่ม month navigation edge cases |

---

## ⚙️ ปรับ `analysis_options.yaml` ให้เข้มขึ้น

ไฟล์: `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    # ยกระดับ warning บางอย่างเป็น error เพื่อบังคับแก้
    invalid_use_of_protected_member: error
    must_be_immutable: error
    avoid_print: warning

linter:
  rules:
    # Riverpod best practices
    avoid_dynamic_calls: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    unnecessary_lambdas: true

    # Code quality
    always_declare_return_types: true
    avoid_empty_else: true
    avoid_redundant_argument_values: true
    cancel_subscriptions: true
    close_sinks: true
    unawaited_futures: true
```

```bash
# หลังแก้ analysis_options.yaml แล้วรัน
flutter analyze
# แก้ทุก warning ก่อน commit
```

---

## 📁 Files Affected Summary

| ไฟล์ | Fixes |
|---|---|
| `lib/src/router/app_router.dart` | #2 |
| `lib/src/feature/todos/usecase/todo.usecase.dart` | #3, #4 |
| `lib/src/feature/todos/usecase/date_tag_usecase.dart` | #4 |
| `lib/src/feature/auth/data/google_sign_in_adapter.dart` | #5 |
| `lib/src/feature/auth/usecase/auth_usecase.dart` | #5, #11 |
| `lib/src/feature/todos/presentation/todo.screen.dart` | #6, #8, #9, #10 |
| `lib/src/feature/auth/presentation/login.screen.dart` | #7 |
| `lib/src/feature/todos/data/repository/todo_repository_impl.dart` | #12 |
| `pubspec.yaml` | #4, #7 |
| `analysis_options.yaml` | เพิ่ม stricter rules |
| `test/router/app_router_test.dart` | สร้างใหม่ |
| `test/feature/todos/usecase/todo_usecase_test.dart` | เพิ่ม test |
| `test/feature/auth/usecase/auth_usecase_test.dart` | เพิ่ม test |
| `test/feature/auth/presentation/login_screen_test.dart` | ขยาย test |
| `test/feature/todos/presentation/todo_screen_test.dart` | สร้างใหม่ |
| `test/feature/todos/presentation/todo_tile_test.dart` | เพิ่ม test |
| `test/feature/todos/presentation/todo_date_tag_widget_test.dart` | เพิ่ม test |
