// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherSnapshot {

 String get locationName; DateTime get updatedAt; CurrentWeather get current; List<HourlyForecastItem> get hourly; List<DailyForecastItem> get daily;
/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherSnapshotCopyWith<WeatherSnapshot> get copyWith => _$WeatherSnapshotCopyWithImpl<WeatherSnapshot>(this as WeatherSnapshot, _$identity);

  /// Serializes this WeatherSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherSnapshot&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.current, current) || other.current == current)&&const DeepCollectionEquality().equals(other.hourly, hourly)&&const DeepCollectionEquality().equals(other.daily, daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locationName,updatedAt,current,const DeepCollectionEquality().hash(hourly),const DeepCollectionEquality().hash(daily));

@override
String toString() {
  return 'WeatherSnapshot(locationName: $locationName, updatedAt: $updatedAt, current: $current, hourly: $hourly, daily: $daily)';
}


}

/// @nodoc
abstract mixin class $WeatherSnapshotCopyWith<$Res>  {
  factory $WeatherSnapshotCopyWith(WeatherSnapshot value, $Res Function(WeatherSnapshot) _then) = _$WeatherSnapshotCopyWithImpl;
@useResult
$Res call({
 String locationName, DateTime updatedAt, CurrentWeather current, List<HourlyForecastItem> hourly, List<DailyForecastItem> daily
});


$CurrentWeatherCopyWith<$Res> get current;

}
/// @nodoc
class _$WeatherSnapshotCopyWithImpl<$Res>
    implements $WeatherSnapshotCopyWith<$Res> {
  _$WeatherSnapshotCopyWithImpl(this._self, this._then);

  final WeatherSnapshot _self;
  final $Res Function(WeatherSnapshot) _then;

/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locationName = null,Object? updatedAt = null,Object? current = null,Object? hourly = null,Object? daily = null,}) {
  return _then(_self.copyWith(
locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurrentWeather,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourlyForecastItem>,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyForecastItem>,
  ));
}
/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<$Res> get current {
  
  return $CurrentWeatherCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherSnapshot].
extension WeatherSnapshotPatterns on WeatherSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _WeatherSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String locationName,  DateTime updatedAt,  CurrentWeather current,  List<HourlyForecastItem> hourly,  List<DailyForecastItem> daily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
return $default(_that.locationName,_that.updatedAt,_that.current,_that.hourly,_that.daily);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String locationName,  DateTime updatedAt,  CurrentWeather current,  List<HourlyForecastItem> hourly,  List<DailyForecastItem> daily)  $default,) {final _that = this;
switch (_that) {
case _WeatherSnapshot():
return $default(_that.locationName,_that.updatedAt,_that.current,_that.hourly,_that.daily);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String locationName,  DateTime updatedAt,  CurrentWeather current,  List<HourlyForecastItem> hourly,  List<DailyForecastItem> daily)?  $default,) {final _that = this;
switch (_that) {
case _WeatherSnapshot() when $default != null:
return $default(_that.locationName,_that.updatedAt,_that.current,_that.hourly,_that.daily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherSnapshot implements WeatherSnapshot {
  const _WeatherSnapshot({required this.locationName, required this.updatedAt, required this.current, required final  List<HourlyForecastItem> hourly, required final  List<DailyForecastItem> daily}): _hourly = hourly,_daily = daily;
  factory _WeatherSnapshot.fromJson(Map<String, dynamic> json) => _$WeatherSnapshotFromJson(json);

@override final  String locationName;
@override final  DateTime updatedAt;
@override final  CurrentWeather current;
 final  List<HourlyForecastItem> _hourly;
@override List<HourlyForecastItem> get hourly {
  if (_hourly is EqualUnmodifiableListView) return _hourly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourly);
}

 final  List<DailyForecastItem> _daily;
@override List<DailyForecastItem> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}


/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherSnapshotCopyWith<_WeatherSnapshot> get copyWith => __$WeatherSnapshotCopyWithImpl<_WeatherSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherSnapshot&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.current, current) || other.current == current)&&const DeepCollectionEquality().equals(other._hourly, _hourly)&&const DeepCollectionEquality().equals(other._daily, _daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locationName,updatedAt,current,const DeepCollectionEquality().hash(_hourly),const DeepCollectionEquality().hash(_daily));

@override
String toString() {
  return 'WeatherSnapshot(locationName: $locationName, updatedAt: $updatedAt, current: $current, hourly: $hourly, daily: $daily)';
}


}

/// @nodoc
abstract mixin class _$WeatherSnapshotCopyWith<$Res> implements $WeatherSnapshotCopyWith<$Res> {
  factory _$WeatherSnapshotCopyWith(_WeatherSnapshot value, $Res Function(_WeatherSnapshot) _then) = __$WeatherSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String locationName, DateTime updatedAt, CurrentWeather current, List<HourlyForecastItem> hourly, List<DailyForecastItem> daily
});


@override $CurrentWeatherCopyWith<$Res> get current;

}
/// @nodoc
class __$WeatherSnapshotCopyWithImpl<$Res>
    implements _$WeatherSnapshotCopyWith<$Res> {
  __$WeatherSnapshotCopyWithImpl(this._self, this._then);

  final _WeatherSnapshot _self;
  final $Res Function(_WeatherSnapshot) _then;

/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationName = null,Object? updatedAt = null,Object? current = null,Object? hourly = null,Object? daily = null,}) {
  return _then(_WeatherSnapshot(
locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurrentWeather,hourly: null == hourly ? _self._hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourlyForecastItem>,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyForecastItem>,
  ));
}

/// Create a copy of WeatherSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<$Res> get current {
  
  return $CurrentWeatherCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// @nodoc
mixin _$CurrentWeather {

 double get temperatureCelsius; double get feelsLikeCelsius; String get condition; String get description; String get iconCode; int get humidityPercent; double get windSpeedKph; DateTime get sunsetAt; int get precipitationChance;
/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<CurrentWeather> get copyWith => _$CurrentWeatherCopyWithImpl<CurrentWeather>(this as CurrentWeather, _$identity);

  /// Serializes this CurrentWeather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentWeather&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.feelsLikeCelsius, feelsLikeCelsius) || other.feelsLikeCelsius == feelsLikeCelsius)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.humidityPercent, humidityPercent) || other.humidityPercent == humidityPercent)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.sunsetAt, sunsetAt) || other.sunsetAt == sunsetAt)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperatureCelsius,feelsLikeCelsius,condition,description,iconCode,humidityPercent,windSpeedKph,sunsetAt,precipitationChance);

@override
String toString() {
  return 'CurrentWeather(temperatureCelsius: $temperatureCelsius, feelsLikeCelsius: $feelsLikeCelsius, condition: $condition, description: $description, iconCode: $iconCode, humidityPercent: $humidityPercent, windSpeedKph: $windSpeedKph, sunsetAt: $sunsetAt, precipitationChance: $precipitationChance)';
}


}

/// @nodoc
abstract mixin class $CurrentWeatherCopyWith<$Res>  {
  factory $CurrentWeatherCopyWith(CurrentWeather value, $Res Function(CurrentWeather) _then) = _$CurrentWeatherCopyWithImpl;
@useResult
$Res call({
 double temperatureCelsius, double feelsLikeCelsius, String condition, String description, String iconCode, int humidityPercent, double windSpeedKph, DateTime sunsetAt, int precipitationChance
});




}
/// @nodoc
class _$CurrentWeatherCopyWithImpl<$Res>
    implements $CurrentWeatherCopyWith<$Res> {
  _$CurrentWeatherCopyWithImpl(this._self, this._then);

  final CurrentWeather _self;
  final $Res Function(CurrentWeather) _then;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperatureCelsius = null,Object? feelsLikeCelsius = null,Object? condition = null,Object? description = null,Object? iconCode = null,Object? humidityPercent = null,Object? windSpeedKph = null,Object? sunsetAt = null,Object? precipitationChance = null,}) {
  return _then(_self.copyWith(
temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,feelsLikeCelsius: null == feelsLikeCelsius ? _self.feelsLikeCelsius : feelsLikeCelsius // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,humidityPercent: null == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,sunsetAt: null == sunsetAt ? _self.sunsetAt : sunsetAt // ignore: cast_nullable_to_non_nullable
as DateTime,precipitationChance: null == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentWeather].
extension CurrentWeatherPatterns on CurrentWeather {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentWeather value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentWeather value)  $default,){
final _that = this;
switch (_that) {
case _CurrentWeather():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentWeather value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperatureCelsius,  double feelsLikeCelsius,  String condition,  String description,  String iconCode,  int humidityPercent,  double windSpeedKph,  DateTime sunsetAt,  int precipitationChance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
return $default(_that.temperatureCelsius,_that.feelsLikeCelsius,_that.condition,_that.description,_that.iconCode,_that.humidityPercent,_that.windSpeedKph,_that.sunsetAt,_that.precipitationChance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperatureCelsius,  double feelsLikeCelsius,  String condition,  String description,  String iconCode,  int humidityPercent,  double windSpeedKph,  DateTime sunsetAt,  int precipitationChance)  $default,) {final _that = this;
switch (_that) {
case _CurrentWeather():
return $default(_that.temperatureCelsius,_that.feelsLikeCelsius,_that.condition,_that.description,_that.iconCode,_that.humidityPercent,_that.windSpeedKph,_that.sunsetAt,_that.precipitationChance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperatureCelsius,  double feelsLikeCelsius,  String condition,  String description,  String iconCode,  int humidityPercent,  double windSpeedKph,  DateTime sunsetAt,  int precipitationChance)?  $default,) {final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
return $default(_that.temperatureCelsius,_that.feelsLikeCelsius,_that.condition,_that.description,_that.iconCode,_that.humidityPercent,_that.windSpeedKph,_that.sunsetAt,_that.precipitationChance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentWeather implements CurrentWeather {
  const _CurrentWeather({required this.temperatureCelsius, required this.feelsLikeCelsius, required this.condition, required this.description, required this.iconCode, required this.humidityPercent, required this.windSpeedKph, required this.sunsetAt, required this.precipitationChance});
  factory _CurrentWeather.fromJson(Map<String, dynamic> json) => _$CurrentWeatherFromJson(json);

@override final  double temperatureCelsius;
@override final  double feelsLikeCelsius;
@override final  String condition;
@override final  String description;
@override final  String iconCode;
@override final  int humidityPercent;
@override final  double windSpeedKph;
@override final  DateTime sunsetAt;
@override final  int precipitationChance;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentWeatherCopyWith<_CurrentWeather> get copyWith => __$CurrentWeatherCopyWithImpl<_CurrentWeather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentWeatherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentWeather&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.feelsLikeCelsius, feelsLikeCelsius) || other.feelsLikeCelsius == feelsLikeCelsius)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.humidityPercent, humidityPercent) || other.humidityPercent == humidityPercent)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.sunsetAt, sunsetAt) || other.sunsetAt == sunsetAt)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperatureCelsius,feelsLikeCelsius,condition,description,iconCode,humidityPercent,windSpeedKph,sunsetAt,precipitationChance);

@override
String toString() {
  return 'CurrentWeather(temperatureCelsius: $temperatureCelsius, feelsLikeCelsius: $feelsLikeCelsius, condition: $condition, description: $description, iconCode: $iconCode, humidityPercent: $humidityPercent, windSpeedKph: $windSpeedKph, sunsetAt: $sunsetAt, precipitationChance: $precipitationChance)';
}


}

/// @nodoc
abstract mixin class _$CurrentWeatherCopyWith<$Res> implements $CurrentWeatherCopyWith<$Res> {
  factory _$CurrentWeatherCopyWith(_CurrentWeather value, $Res Function(_CurrentWeather) _then) = __$CurrentWeatherCopyWithImpl;
@override @useResult
$Res call({
 double temperatureCelsius, double feelsLikeCelsius, String condition, String description, String iconCode, int humidityPercent, double windSpeedKph, DateTime sunsetAt, int precipitationChance
});




}
/// @nodoc
class __$CurrentWeatherCopyWithImpl<$Res>
    implements _$CurrentWeatherCopyWith<$Res> {
  __$CurrentWeatherCopyWithImpl(this._self, this._then);

  final _CurrentWeather _self;
  final $Res Function(_CurrentWeather) _then;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperatureCelsius = null,Object? feelsLikeCelsius = null,Object? condition = null,Object? description = null,Object? iconCode = null,Object? humidityPercent = null,Object? windSpeedKph = null,Object? sunsetAt = null,Object? precipitationChance = null,}) {
  return _then(_CurrentWeather(
temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,feelsLikeCelsius: null == feelsLikeCelsius ? _self.feelsLikeCelsius : feelsLikeCelsius // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,humidityPercent: null == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,sunsetAt: null == sunsetAt ? _self.sunsetAt : sunsetAt // ignore: cast_nullable_to_non_nullable
as DateTime,precipitationChance: null == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HourlyForecastItem {

 DateTime get time; double get temperatureCelsius; String get condition; String get iconCode; int get precipitationChance;
/// Create a copy of HourlyForecastItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyForecastItemCopyWith<HourlyForecastItem> get copyWith => _$HourlyForecastItemCopyWithImpl<HourlyForecastItem>(this as HourlyForecastItem, _$identity);

  /// Serializes this HourlyForecastItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyForecastItem&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperatureCelsius,condition,iconCode,precipitationChance);

@override
String toString() {
  return 'HourlyForecastItem(time: $time, temperatureCelsius: $temperatureCelsius, condition: $condition, iconCode: $iconCode, precipitationChance: $precipitationChance)';
}


}

/// @nodoc
abstract mixin class $HourlyForecastItemCopyWith<$Res>  {
  factory $HourlyForecastItemCopyWith(HourlyForecastItem value, $Res Function(HourlyForecastItem) _then) = _$HourlyForecastItemCopyWithImpl;
@useResult
$Res call({
 DateTime time, double temperatureCelsius, String condition, String iconCode, int precipitationChance
});




}
/// @nodoc
class _$HourlyForecastItemCopyWithImpl<$Res>
    implements $HourlyForecastItemCopyWith<$Res> {
  _$HourlyForecastItemCopyWithImpl(this._self, this._then);

  final HourlyForecastItem _self;
  final $Res Function(HourlyForecastItem) _then;

/// Create a copy of HourlyForecastItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperatureCelsius = null,Object? condition = null,Object? iconCode = null,Object? precipitationChance = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,precipitationChance: null == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyForecastItem].
extension HourlyForecastItemPatterns on HourlyForecastItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyForecastItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyForecastItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyForecastItem value)  $default,){
final _that = this;
switch (_that) {
case _HourlyForecastItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyForecastItem value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyForecastItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double temperatureCelsius,  String condition,  String iconCode,  int precipitationChance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyForecastItem() when $default != null:
return $default(_that.time,_that.temperatureCelsius,_that.condition,_that.iconCode,_that.precipitationChance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double temperatureCelsius,  String condition,  String iconCode,  int precipitationChance)  $default,) {final _that = this;
switch (_that) {
case _HourlyForecastItem():
return $default(_that.time,_that.temperatureCelsius,_that.condition,_that.iconCode,_that.precipitationChance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double temperatureCelsius,  String condition,  String iconCode,  int precipitationChance)?  $default,) {final _that = this;
switch (_that) {
case _HourlyForecastItem() when $default != null:
return $default(_that.time,_that.temperatureCelsius,_that.condition,_that.iconCode,_that.precipitationChance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyForecastItem implements HourlyForecastItem {
  const _HourlyForecastItem({required this.time, required this.temperatureCelsius, required this.condition, required this.iconCode, required this.precipitationChance});
  factory _HourlyForecastItem.fromJson(Map<String, dynamic> json) => _$HourlyForecastItemFromJson(json);

@override final  DateTime time;
@override final  double temperatureCelsius;
@override final  String condition;
@override final  String iconCode;
@override final  int precipitationChance;

/// Create a copy of HourlyForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyForecastItemCopyWith<_HourlyForecastItem> get copyWith => __$HourlyForecastItemCopyWithImpl<_HourlyForecastItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyForecastItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyForecastItem&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperatureCelsius,condition,iconCode,precipitationChance);

@override
String toString() {
  return 'HourlyForecastItem(time: $time, temperatureCelsius: $temperatureCelsius, condition: $condition, iconCode: $iconCode, precipitationChance: $precipitationChance)';
}


}

/// @nodoc
abstract mixin class _$HourlyForecastItemCopyWith<$Res> implements $HourlyForecastItemCopyWith<$Res> {
  factory _$HourlyForecastItemCopyWith(_HourlyForecastItem value, $Res Function(_HourlyForecastItem) _then) = __$HourlyForecastItemCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double temperatureCelsius, String condition, String iconCode, int precipitationChance
});




}
/// @nodoc
class __$HourlyForecastItemCopyWithImpl<$Res>
    implements _$HourlyForecastItemCopyWith<$Res> {
  __$HourlyForecastItemCopyWithImpl(this._self, this._then);

  final _HourlyForecastItem _self;
  final $Res Function(_HourlyForecastItem) _then;

/// Create a copy of HourlyForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperatureCelsius = null,Object? condition = null,Object? iconCode = null,Object? precipitationChance = null,}) {
  return _then(_HourlyForecastItem(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,precipitationChance: null == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DailyForecastItem {

 DateTime get date; String get condition; String get iconCode; double get highCelsius; double get lowCelsius; int get precipitationChance;
/// Create a copy of DailyForecastItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyForecastItemCopyWith<DailyForecastItem> get copyWith => _$DailyForecastItemCopyWithImpl<DailyForecastItem>(this as DailyForecastItem, _$identity);

  /// Serializes this DailyForecastItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyForecastItem&&(identical(other.date, date) || other.date == date)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.highCelsius, highCelsius) || other.highCelsius == highCelsius)&&(identical(other.lowCelsius, lowCelsius) || other.lowCelsius == lowCelsius)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,condition,iconCode,highCelsius,lowCelsius,precipitationChance);

@override
String toString() {
  return 'DailyForecastItem(date: $date, condition: $condition, iconCode: $iconCode, highCelsius: $highCelsius, lowCelsius: $lowCelsius, precipitationChance: $precipitationChance)';
}


}

/// @nodoc
abstract mixin class $DailyForecastItemCopyWith<$Res>  {
  factory $DailyForecastItemCopyWith(DailyForecastItem value, $Res Function(DailyForecastItem) _then) = _$DailyForecastItemCopyWithImpl;
@useResult
$Res call({
 DateTime date, String condition, String iconCode, double highCelsius, double lowCelsius, int precipitationChance
});




}
/// @nodoc
class _$DailyForecastItemCopyWithImpl<$Res>
    implements $DailyForecastItemCopyWith<$Res> {
  _$DailyForecastItemCopyWithImpl(this._self, this._then);

  final DailyForecastItem _self;
  final $Res Function(DailyForecastItem) _then;

/// Create a copy of DailyForecastItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? condition = null,Object? iconCode = null,Object? highCelsius = null,Object? lowCelsius = null,Object? precipitationChance = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,highCelsius: null == highCelsius ? _self.highCelsius : highCelsius // ignore: cast_nullable_to_non_nullable
as double,lowCelsius: null == lowCelsius ? _self.lowCelsius : lowCelsius // ignore: cast_nullable_to_non_nullable
as double,precipitationChance: null == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyForecastItem].
extension DailyForecastItemPatterns on DailyForecastItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyForecastItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyForecastItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyForecastItem value)  $default,){
final _that = this;
switch (_that) {
case _DailyForecastItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyForecastItem value)?  $default,){
final _that = this;
switch (_that) {
case _DailyForecastItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String condition,  String iconCode,  double highCelsius,  double lowCelsius,  int precipitationChance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyForecastItem() when $default != null:
return $default(_that.date,_that.condition,_that.iconCode,_that.highCelsius,_that.lowCelsius,_that.precipitationChance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String condition,  String iconCode,  double highCelsius,  double lowCelsius,  int precipitationChance)  $default,) {final _that = this;
switch (_that) {
case _DailyForecastItem():
return $default(_that.date,_that.condition,_that.iconCode,_that.highCelsius,_that.lowCelsius,_that.precipitationChance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String condition,  String iconCode,  double highCelsius,  double lowCelsius,  int precipitationChance)?  $default,) {final _that = this;
switch (_that) {
case _DailyForecastItem() when $default != null:
return $default(_that.date,_that.condition,_that.iconCode,_that.highCelsius,_that.lowCelsius,_that.precipitationChance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyForecastItem implements DailyForecastItem {
  const _DailyForecastItem({required this.date, required this.condition, required this.iconCode, required this.highCelsius, required this.lowCelsius, required this.precipitationChance});
  factory _DailyForecastItem.fromJson(Map<String, dynamic> json) => _$DailyForecastItemFromJson(json);

@override final  DateTime date;
@override final  String condition;
@override final  String iconCode;
@override final  double highCelsius;
@override final  double lowCelsius;
@override final  int precipitationChance;

/// Create a copy of DailyForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyForecastItemCopyWith<_DailyForecastItem> get copyWith => __$DailyForecastItemCopyWithImpl<_DailyForecastItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyForecastItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyForecastItem&&(identical(other.date, date) || other.date == date)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.highCelsius, highCelsius) || other.highCelsius == highCelsius)&&(identical(other.lowCelsius, lowCelsius) || other.lowCelsius == lowCelsius)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,condition,iconCode,highCelsius,lowCelsius,precipitationChance);

@override
String toString() {
  return 'DailyForecastItem(date: $date, condition: $condition, iconCode: $iconCode, highCelsius: $highCelsius, lowCelsius: $lowCelsius, precipitationChance: $precipitationChance)';
}


}

/// @nodoc
abstract mixin class _$DailyForecastItemCopyWith<$Res> implements $DailyForecastItemCopyWith<$Res> {
  factory _$DailyForecastItemCopyWith(_DailyForecastItem value, $Res Function(_DailyForecastItem) _then) = __$DailyForecastItemCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String condition, String iconCode, double highCelsius, double lowCelsius, int precipitationChance
});




}
/// @nodoc
class __$DailyForecastItemCopyWithImpl<$Res>
    implements _$DailyForecastItemCopyWith<$Res> {
  __$DailyForecastItemCopyWithImpl(this._self, this._then);

  final _DailyForecastItem _self;
  final $Res Function(_DailyForecastItem) _then;

/// Create a copy of DailyForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? condition = null,Object? iconCode = null,Object? highCelsius = null,Object? lowCelsius = null,Object? precipitationChance = null,}) {
  return _then(_DailyForecastItem(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,highCelsius: null == highCelsius ? _self.highCelsius : highCelsius // ignore: cast_nullable_to_non_nullable
as double,lowCelsius: null == lowCelsius ? _self.lowCelsius : lowCelsius // ignore: cast_nullable_to_non_nullable
as double,precipitationChance: null == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
