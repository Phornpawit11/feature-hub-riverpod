// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Todo {

 String get id; String get title; DateTime get createdAt; bool get isCompleted; TodoPriority get priority; DateTime? get dueDate; String? get colorValue;
/// Create a copy of Todo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoCopyWith<Todo> get copyWith => _$TodoCopyWithImpl<Todo>(this as Todo, _$identity);

  /// Serializes this Todo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Todo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,isCompleted,priority,dueDate,colorValue);

@override
String toString() {
  return 'Todo(id: $id, title: $title, createdAt: $createdAt, isCompleted: $isCompleted, priority: $priority, dueDate: $dueDate, colorValue: $colorValue)';
}


}

/// @nodoc
abstract mixin class $TodoCopyWith<$Res>  {
  factory $TodoCopyWith(Todo value, $Res Function(Todo) _then) = _$TodoCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime createdAt, bool isCompleted, TodoPriority priority, DateTime? dueDate, String? colorValue
});




}
/// @nodoc
class _$TodoCopyWithImpl<$Res>
    implements $TodoCopyWith<$Res> {
  _$TodoCopyWithImpl(this._self, this._then);

  final Todo _self;
  final $Res Function(Todo) _then;

/// Create a copy of Todo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? isCompleted = null,Object? priority = null,Object? dueDate = freezed,Object? colorValue = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TodoPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Todo].
extension TodoPatterns on Todo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Todo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Todo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Todo value)  $default,){
final _that = this;
switch (_that) {
case _Todo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Todo value)?  $default,){
final _that = this;
switch (_that) {
case _Todo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  bool isCompleted,  TodoPriority priority,  DateTime? dueDate,  String? colorValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Todo() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.isCompleted,_that.priority,_that.dueDate,_that.colorValue);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  bool isCompleted,  TodoPriority priority,  DateTime? dueDate,  String? colorValue)  $default,) {final _that = this;
switch (_that) {
case _Todo():
return $default(_that.id,_that.title,_that.createdAt,_that.isCompleted,_that.priority,_that.dueDate,_that.colorValue);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime createdAt,  bool isCompleted,  TodoPriority priority,  DateTime? dueDate,  String? colorValue)?  $default,) {final _that = this;
switch (_that) {
case _Todo() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.isCompleted,_that.priority,_that.dueDate,_that.colorValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Todo implements Todo {
   _Todo({required this.id, required this.title, required this.createdAt, required this.isCompleted, this.priority = TodoPriority.medium, this.dueDate, this.colorValue});
  factory _Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime createdAt;
@override final  bool isCompleted;
@override@JsonKey() final  TodoPriority priority;
@override final  DateTime? dueDate;
@override final  String? colorValue;

/// Create a copy of Todo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoCopyWith<_Todo> get copyWith => __$TodoCopyWithImpl<_Todo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Todo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,isCompleted,priority,dueDate,colorValue);

@override
String toString() {
  return 'Todo(id: $id, title: $title, createdAt: $createdAt, isCompleted: $isCompleted, priority: $priority, dueDate: $dueDate, colorValue: $colorValue)';
}


}

/// @nodoc
abstract mixin class _$TodoCopyWith<$Res> implements $TodoCopyWith<$Res> {
  factory _$TodoCopyWith(_Todo value, $Res Function(_Todo) _then) = __$TodoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime createdAt, bool isCompleted, TodoPriority priority, DateTime? dueDate, String? colorValue
});




}
/// @nodoc
class __$TodoCopyWithImpl<$Res>
    implements _$TodoCopyWith<$Res> {
  __$TodoCopyWithImpl(this._self, this._then);

  final _Todo _self;
  final $Res Function(_Todo) _then;

/// Create a copy of Todo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? isCompleted = null,Object? priority = null,Object? dueDate = freezed,Object? colorValue = freezed,}) {
  return _then(_Todo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TodoPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
