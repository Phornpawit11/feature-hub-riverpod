import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_text_field.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/todo.usecase.dart';

class TodoScreen extends HookConsumerWidget {
  const TodoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListAsync = ref.watch(todoUsecaseProvider);
    final textEditingController = useTextEditingController();
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    void submitTodo() {
      final title = textEditingController.text.trim();
      if (title.isEmpty) return;

      ref.read(todoUsecaseProvider.notifier).addTodo(title);
      textEditingController.clear();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8.0,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: textEditingController,
                    hintText: 'Add a new task',
                    prefixIcon: Icons.edit_outlined,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => submitTodo(),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: submitTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            todoListAsync.when(
              data: (todos) {
                if (todos.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('ยังไม่มี todo, ลองเพิ่มรายการแรกดู'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: todos.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: cs.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            todo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(
                              color: todo.isCompleted
                                  ? cs.onSurfaceVariant
                                  : cs.onSurface,
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) {
                              ref
                                  .read(todoUsecaseProvider.notifier)
                                  .toggleTodo(todo.id);
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: cs.error),
                            tooltip: 'Delete todo',
                            onPressed: () {
                              ref
                                  .read(todoUsecaseProvider.notifier)
                                  .deleteTodo(todo.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('เกิดข้อผิดพลาด: $err')),
            ),
          ],
        ),
      ),
    );
  }
}
