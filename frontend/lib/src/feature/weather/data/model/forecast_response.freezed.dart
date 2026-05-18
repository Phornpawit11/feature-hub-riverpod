// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForecastResponse {

@JsonKey(name: "cod") String get cod;@JsonKey(name: "message") int? get message;@JsonKey(name: "cnt") int get cnt;@JsonKey(name: "list") List<ListElement> get list;@JsonKey(name: "city") City get city;
/// Create a copy of ForecastResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastResponseCopyWith<ForecastResponse> get copyWith => _$ForecastResponseCopyWithImpl<ForecastResponse>(this as ForecastResponse, _$identity);

  /// Serializes this ForecastResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastResponse&&(identical(other.cod, cod) || other.cod == cod)&&(identical(other.message, message) || other.message == message)&&(identical(other.cnt, cnt) || other.cnt == cnt)&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cod,message,cnt,const DeepCollectionEquality().hash(list),city);

@override
String toString() {
  return 'ForecastResponse(cod: $cod, message: $message, cnt: $cnt, list: $list, city: $city)';
}


}

/// @nodoc
abstract mixin class $ForecastResponseCopyWith<$Res>  {
  factory $ForecastResponseCopyWith(ForecastResponse value, $Res Function(ForecastResponse) _then) = _$ForecastResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "cod") String cod,@JsonKey(name: "message") int? message,@JsonKey(name: "cnt") int cnt,@JsonKey(name: "list") List<ListElement> list,@JsonKey(name: "city") City city
});


$CityCopyWith<$Res> get city;

}
/// @nodoc
class _$ForecastResponseCopyWithImpl<$Res>
    implements $ForecastResponseCopyWith<$Res> {
  _$ForecastResponseCopyWithImpl(this._self, this._then);

  final ForecastResponse _self;
  final $Res Function(ForecastResponse) _then;

/// Create a copy of ForecastResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cod = null,Object? message = freezed,Object? cnt = null,Object? list = null,Object? city = null,}) {
  return _then(_self.copyWith(
cod: null == cod ? _self.cod : cod // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as int?,cnt: null == cnt ? _self.cnt : cnt // ignore: cast_nullable_to_non_nullable
as int,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ListElement>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as City,
  ));
}
/// Create a copy of ForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityCopyWith<$Res> get city {
  
  return $CityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForecastResponse].
extension ForecastResponsePatterns on ForecastResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastResponse value)  $default,){
final _that = this;
switch (_that) {
case _ForecastResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "cod")  String cod, @JsonKey(name: "message")  int? message, @JsonKey(name: "cnt")  int cnt, @JsonKey(name: "list")  List<ListElement> list, @JsonKey(name: "city")  City city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastResponse() when $default != null:
return $default(_that.cod,_that.message,_that.cnt,_that.list,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "cod")  String cod, @JsonKey(name: "message")  int? message, @JsonKey(name: "cnt")  int cnt, @JsonKey(name: "list")  List<ListElement> list, @JsonKey(name: "city")  City city)  $default,) {final _that = this;
switch (_that) {
case _ForecastResponse():
return $default(_that.cod,_that.message,_that.cnt,_that.list,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "cod")  String cod, @JsonKey(name: "message")  int? message, @JsonKey(name: "cnt")  int cnt, @JsonKey(name: "list")  List<ListElement> list, @JsonKey(name: "city")  City city)?  $default,) {final _that = this;
switch (_that) {
case _ForecastResponse() when $default != null:
return $default(_that.cod,_that.message,_that.cnt,_that.list,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastResponse implements ForecastResponse {
  const _ForecastResponse({@JsonKey(name: "cod") required this.cod, @JsonKey(name: "message") this.message, @JsonKey(name: "cnt") required this.cnt, @JsonKey(name: "list") required final  List<ListElement> list, @JsonKey(name: "city") required this.city}): _list = list;
  factory _ForecastResponse.fromJson(Map<String, dynamic> json) => _$ForecastResponseFromJson(json);

@override@JsonKey(name: "cod") final  String cod;
@override@JsonKey(name: "message") final  int? message;
@override@JsonKey(name: "cnt") final  int cnt;
 final  List<ListElement> _list;
@override@JsonKey(name: "list") List<ListElement> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey(name: "city") final  City city;

/// Create a copy of ForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastResponseCopyWith<_ForecastResponse> get copyWith => __$ForecastResponseCopyWithImpl<_ForecastResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastResponse&&(identical(other.cod, cod) || other.cod == cod)&&(identical(other.message, message) || other.message == message)&&(identical(other.cnt, cnt) || other.cnt == cnt)&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cod,message,cnt,const DeepCollectionEquality().hash(_list),city);

@override
String toString() {
  return 'ForecastResponse(cod: $cod, message: $message, cnt: $cnt, list: $list, city: $city)';
}


}

/// @nodoc
abstract mixin class _$ForecastResponseCopyWith<$Res> implements $ForecastResponseCopyWith<$Res> {
  factory _$ForecastResponseCopyWith(_ForecastResponse value, $Res Function(_ForecastResponse) _then) = __$ForecastResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "cod") String cod,@JsonKey(name: "message") int? message,@JsonKey(name: "cnt") int cnt,@JsonKey(name: "list") List<ListElement> list,@JsonKey(name: "city") City city
});


@override $CityCopyWith<$Res> get city;

}
/// @nodoc
class __$ForecastResponseCopyWithImpl<$Res>
    implements _$ForecastResponseCopyWith<$Res> {
  __$ForecastResponseCopyWithImpl(this._self, this._then);

  final _ForecastResponse _self;
  final $Res Function(_ForecastResponse) _then;

/// Create a copy of ForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cod = null,Object? message = freezed,Object? cnt = null,Object? list = null,Object? city = null,}) {
  return _then(_ForecastResponse(
cod: null == cod ? _self.cod : cod // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as int?,cnt: null == cnt ? _self.cnt : cnt // ignore: cast_nullable_to_non_nullable
as int,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ListElement>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as City,
  ));
}

/// Create a copy of ForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityCopyWith<$Res> get city {
  
  return $CityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// @nodoc
mixin _$City {

@JsonKey(name: "id") int get id;@JsonKey(name: "name") String get name;@JsonKey(name: "coord") Coord get coord;@JsonKey(name: "country") String get country;@JsonKey(name: "population") int? get population;@JsonKey(name: "timezone") int get timezone;@JsonKey(name: "sunrise") int get sunrise;@JsonKey(name: "sunset") int get sunset;
/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityCopyWith<City> get copyWith => _$CityCopyWithImpl<City>(this as City, _$identity);

  /// Serializes this City to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is City&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coord, coord) || other.coord == coord)&&(identical(other.country, country) || other.country == country)&&(identical(other.population, population) || other.population == population)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coord,country,population,timezone,sunrise,sunset);

@override
String toString() {
  return 'City(id: $id, name: $name, coord: $coord, country: $country, population: $population, timezone: $timezone, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class $CityCopyWith<$Res>  {
  factory $CityCopyWith(City value, $Res Function(City) _then) = _$CityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "name") String name,@JsonKey(name: "coord") Coord coord,@JsonKey(name: "country") String country,@JsonKey(name: "population") int? population,@JsonKey(name: "timezone") int timezone,@JsonKey(name: "sunrise") int sunrise,@JsonKey(name: "sunset") int sunset
});


$CoordCopyWith<$Res> get coord;

}
/// @nodoc
class _$CityCopyWithImpl<$Res>
    implements $CityCopyWith<$Res> {
  _$CityCopyWithImpl(this._self, this._then);

  final City _self;
  final $Res Function(City) _then;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? coord = null,Object? country = null,Object? population = freezed,Object? timezone = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coord: null == coord ? _self.coord : coord // ignore: cast_nullable_to_non_nullable
as Coord,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as int?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as int,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordCopyWith<$Res> get coord {
  
  return $CoordCopyWith<$Res>(_self.coord, (value) {
    return _then(_self.copyWith(coord: value));
  });
}
}


/// Adds pattern-matching-related methods to [City].
extension CityPatterns on City {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _City value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _City() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _City value)  $default,){
final _that = this;
switch (_that) {
case _City():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _City value)?  $default,){
final _that = this;
switch (_that) {
case _City() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String name, @JsonKey(name: "coord")  Coord coord, @JsonKey(name: "country")  String country, @JsonKey(name: "population")  int? population, @JsonKey(name: "timezone")  int timezone, @JsonKey(name: "sunrise")  int sunrise, @JsonKey(name: "sunset")  int sunset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _City() when $default != null:
return $default(_that.id,_that.name,_that.coord,_that.country,_that.population,_that.timezone,_that.sunrise,_that.sunset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String name, @JsonKey(name: "coord")  Coord coord, @JsonKey(name: "country")  String country, @JsonKey(name: "population")  int? population, @JsonKey(name: "timezone")  int timezone, @JsonKey(name: "sunrise")  int sunrise, @JsonKey(name: "sunset")  int sunset)  $default,) {final _that = this;
switch (_that) {
case _City():
return $default(_that.id,_that.name,_that.coord,_that.country,_that.population,_that.timezone,_that.sunrise,_that.sunset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String name, @JsonKey(name: "coord")  Coord coord, @JsonKey(name: "country")  String country, @JsonKey(name: "population")  int? population, @JsonKey(name: "timezone")  int timezone, @JsonKey(name: "sunrise")  int sunrise, @JsonKey(name: "sunset")  int sunset)?  $default,) {final _that = this;
switch (_that) {
case _City() when $default != null:
return $default(_that.id,_that.name,_that.coord,_that.country,_that.population,_that.timezone,_that.sunrise,_that.sunset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _City implements City {
  const _City({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "coord") required this.coord, @JsonKey(name: "country") required this.country, @JsonKey(name: "population") this.population, @JsonKey(name: "timezone") required this.timezone, @JsonKey(name: "sunrise") required this.sunrise, @JsonKey(name: "sunset") required this.sunset});
  factory _City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "coord") final  Coord coord;
@override@JsonKey(name: "country") final  String country;
@override@JsonKey(name: "population") final  int? population;
@override@JsonKey(name: "timezone") final  int timezone;
@override@JsonKey(name: "sunrise") final  int sunrise;
@override@JsonKey(name: "sunset") final  int sunset;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityCopyWith<_City> get copyWith => __$CityCopyWithImpl<_City>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _City&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coord, coord) || other.coord == coord)&&(identical(other.country, country) || other.country == country)&&(identical(other.population, population) || other.population == population)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coord,country,population,timezone,sunrise,sunset);

@override
String toString() {
  return 'City(id: $id, name: $name, coord: $coord, country: $country, population: $population, timezone: $timezone, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class _$CityCopyWith<$Res> implements $CityCopyWith<$Res> {
  factory _$CityCopyWith(_City value, $Res Function(_City) _then) = __$CityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "name") String name,@JsonKey(name: "coord") Coord coord,@JsonKey(name: "country") String country,@JsonKey(name: "population") int? population,@JsonKey(name: "timezone") int timezone,@JsonKey(name: "sunrise") int sunrise,@JsonKey(name: "sunset") int sunset
});


@override $CoordCopyWith<$Res> get coord;

}
/// @nodoc
class __$CityCopyWithImpl<$Res>
    implements _$CityCopyWith<$Res> {
  __$CityCopyWithImpl(this._self, this._then);

  final _City _self;
  final $Res Function(_City) _then;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? coord = null,Object? country = null,Object? population = freezed,Object? timezone = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_City(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coord: null == coord ? _self.coord : coord // ignore: cast_nullable_to_non_nullable
as Coord,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as int?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as int,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordCopyWith<$Res> get coord {
  
  return $CoordCopyWith<$Res>(_self.coord, (value) {
    return _then(_self.copyWith(coord: value));
  });
}
}


/// @nodoc
mixin _$Coord {

@JsonKey(name: "lat") double get lat;@JsonKey(name: "lon") double get lon;
/// Create a copy of Coord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordCopyWith<Coord> get copyWith => _$CoordCopyWithImpl<Coord>(this as Coord, _$identity);

  /// Serializes this Coord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coord&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lon);

@override
String toString() {
  return 'Coord(lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $CoordCopyWith<$Res>  {
  factory $CoordCopyWith(Coord value, $Res Function(Coord) _then) = _$CoordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "lat") double lat,@JsonKey(name: "lon") double lon
});




}
/// @nodoc
class _$CoordCopyWithImpl<$Res>
    implements $CoordCopyWith<$Res> {
  _$CoordCopyWithImpl(this._self, this._then);

  final Coord _self;
  final $Res Function(Coord) _then;

/// Create a copy of Coord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lon = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Coord].
extension CoordPatterns on Coord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coord value)  $default,){
final _that = this;
switch (_that) {
case _Coord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coord value)?  $default,){
final _that = this;
switch (_that) {
case _Coord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "lat")  double lat, @JsonKey(name: "lon")  double lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coord() when $default != null:
return $default(_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "lat")  double lat, @JsonKey(name: "lon")  double lon)  $default,) {final _that = this;
switch (_that) {
case _Coord():
return $default(_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "lat")  double lat, @JsonKey(name: "lon")  double lon)?  $default,) {final _that = this;
switch (_that) {
case _Coord() when $default != null:
return $default(_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coord implements Coord {
  const _Coord({@JsonKey(name: "lat") required this.lat, @JsonKey(name: "lon") required this.lon});
  factory _Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);

@override@JsonKey(name: "lat") final  double lat;
@override@JsonKey(name: "lon") final  double lon;

/// Create a copy of Coord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordCopyWith<_Coord> get copyWith => __$CoordCopyWithImpl<_Coord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coord&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lon);

@override
String toString() {
  return 'Coord(lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$CoordCopyWith<$Res> implements $CoordCopyWith<$Res> {
  factory _$CoordCopyWith(_Coord value, $Res Function(_Coord) _then) = __$CoordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "lat") double lat,@JsonKey(name: "lon") double lon
});




}
/// @nodoc
class __$CoordCopyWithImpl<$Res>
    implements _$CoordCopyWith<$Res> {
  __$CoordCopyWithImpl(this._self, this._then);

  final _Coord _self;
  final $Res Function(_Coord) _then;

/// Create a copy of Coord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lon = null,}) {
  return _then(_Coord(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ListElement {

@JsonKey(name: "dt") int get dt;@JsonKey(name: "main") MainClass get main;@JsonKey(name: "weather") List<Weather> get weather;@JsonKey(name: "clouds") Clouds get clouds;@JsonKey(name: "wind") Wind get wind;@JsonKey(name: "visibility") int get visibility;@JsonKey(name: "pop") double get pop;@JsonKey(name: "rain") Rain? get rain;@JsonKey(name: "sys") Sys get sys;@JsonKey(name: "dt_txt") DateTime get dtTxt;
/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListElementCopyWith<ListElement> get copyWith => _$ListElementCopyWithImpl<ListElement>(this as ListElement, _$identity);

  /// Serializes this ListElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListElement&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other.weather, weather)&&(identical(other.clouds, clouds) || other.clouds == clouds)&&(identical(other.wind, wind) || other.wind == wind)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.pop, pop) || other.pop == pop)&&(identical(other.rain, rain) || other.rain == rain)&&(identical(other.sys, sys) || other.sys == sys)&&(identical(other.dtTxt, dtTxt) || other.dtTxt == dtTxt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dt,main,const DeepCollectionEquality().hash(weather),clouds,wind,visibility,pop,rain,sys,dtTxt);

@override
String toString() {
  return 'ListElement(dt: $dt, main: $main, weather: $weather, clouds: $clouds, wind: $wind, visibility: $visibility, pop: $pop, rain: $rain, sys: $sys, dtTxt: $dtTxt)';
}


}

/// @nodoc
abstract mixin class $ListElementCopyWith<$Res>  {
  factory $ListElementCopyWith(ListElement value, $Res Function(ListElement) _then) = _$ListElementCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "dt") int dt,@JsonKey(name: "main") MainClass main,@JsonKey(name: "weather") List<Weather> weather,@JsonKey(name: "clouds") Clouds clouds,@JsonKey(name: "wind") Wind wind,@JsonKey(name: "visibility") int visibility,@JsonKey(name: "pop") double pop,@JsonKey(name: "rain") Rain? rain,@JsonKey(name: "sys") Sys sys,@JsonKey(name: "dt_txt") DateTime dtTxt
});


$MainClassCopyWith<$Res> get main;$CloudsCopyWith<$Res> get clouds;$WindCopyWith<$Res> get wind;$RainCopyWith<$Res>? get rain;$SysCopyWith<$Res> get sys;

}
/// @nodoc
class _$ListElementCopyWithImpl<$Res>
    implements $ListElementCopyWith<$Res> {
  _$ListElementCopyWithImpl(this._self, this._then);

  final ListElement _self;
  final $Res Function(ListElement) _then;

/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dt = null,Object? main = null,Object? weather = null,Object? clouds = null,Object? wind = null,Object? visibility = null,Object? pop = null,Object? rain = freezed,Object? sys = null,Object? dtTxt = null,}) {
  return _then(_self.copyWith(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as MainClass,weather: null == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as List<Weather>,clouds: null == clouds ? _self.clouds : clouds // ignore: cast_nullable_to_non_nullable
as Clouds,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as Wind,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as int,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,rain: freezed == rain ? _self.rain : rain // ignore: cast_nullable_to_non_nullable
as Rain?,sys: null == sys ? _self.sys : sys // ignore: cast_nullable_to_non_nullable
as Sys,dtTxt: null == dtTxt ? _self.dtTxt : dtTxt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainClassCopyWith<$Res> get main {
  
  return $MainClassCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudsCopyWith<$Res> get clouds {
  
  return $CloudsCopyWith<$Res>(_self.clouds, (value) {
    return _then(_self.copyWith(clouds: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WindCopyWith<$Res> get wind {
  
  return $WindCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RainCopyWith<$Res>? get rain {
    if (_self.rain == null) {
    return null;
  }

  return $RainCopyWith<$Res>(_self.rain!, (value) {
    return _then(_self.copyWith(rain: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SysCopyWith<$Res> get sys {
  
  return $SysCopyWith<$Res>(_self.sys, (value) {
    return _then(_self.copyWith(sys: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListElement].
extension ListElementPatterns on ListElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListElement value)  $default,){
final _that = this;
switch (_that) {
case _ListElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListElement value)?  $default,){
final _that = this;
switch (_that) {
case _ListElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "dt")  int dt, @JsonKey(name: "main")  MainClass main, @JsonKey(name: "weather")  List<Weather> weather, @JsonKey(name: "clouds")  Clouds clouds, @JsonKey(name: "wind")  Wind wind, @JsonKey(name: "visibility")  int visibility, @JsonKey(name: "pop")  double pop, @JsonKey(name: "rain")  Rain? rain, @JsonKey(name: "sys")  Sys sys, @JsonKey(name: "dt_txt")  DateTime dtTxt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListElement() when $default != null:
return $default(_that.dt,_that.main,_that.weather,_that.clouds,_that.wind,_that.visibility,_that.pop,_that.rain,_that.sys,_that.dtTxt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "dt")  int dt, @JsonKey(name: "main")  MainClass main, @JsonKey(name: "weather")  List<Weather> weather, @JsonKey(name: "clouds")  Clouds clouds, @JsonKey(name: "wind")  Wind wind, @JsonKey(name: "visibility")  int visibility, @JsonKey(name: "pop")  double pop, @JsonKey(name: "rain")  Rain? rain, @JsonKey(name: "sys")  Sys sys, @JsonKey(name: "dt_txt")  DateTime dtTxt)  $default,) {final _that = this;
switch (_that) {
case _ListElement():
return $default(_that.dt,_that.main,_that.weather,_that.clouds,_that.wind,_that.visibility,_that.pop,_that.rain,_that.sys,_that.dtTxt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "dt")  int dt, @JsonKey(name: "main")  MainClass main, @JsonKey(name: "weather")  List<Weather> weather, @JsonKey(name: "clouds")  Clouds clouds, @JsonKey(name: "wind")  Wind wind, @JsonKey(name: "visibility")  int visibility, @JsonKey(name: "pop")  double pop, @JsonKey(name: "rain")  Rain? rain, @JsonKey(name: "sys")  Sys sys, @JsonKey(name: "dt_txt")  DateTime dtTxt)?  $default,) {final _that = this;
switch (_that) {
case _ListElement() when $default != null:
return $default(_that.dt,_that.main,_that.weather,_that.clouds,_that.wind,_that.visibility,_that.pop,_that.rain,_that.sys,_that.dtTxt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListElement implements ListElement {
  const _ListElement({@JsonKey(name: "dt") required this.dt, @JsonKey(name: "main") required this.main, @JsonKey(name: "weather") required final  List<Weather> weather, @JsonKey(name: "clouds") required this.clouds, @JsonKey(name: "wind") required this.wind, @JsonKey(name: "visibility") required this.visibility, @JsonKey(name: "pop") required this.pop, @JsonKey(name: "rain") this.rain, @JsonKey(name: "sys") required this.sys, @JsonKey(name: "dt_txt") required this.dtTxt}): _weather = weather;
  factory _ListElement.fromJson(Map<String, dynamic> json) => _$ListElementFromJson(json);

@override@JsonKey(name: "dt") final  int dt;
@override@JsonKey(name: "main") final  MainClass main;
 final  List<Weather> _weather;
@override@JsonKey(name: "weather") List<Weather> get weather {
  if (_weather is EqualUnmodifiableListView) return _weather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weather);
}

@override@JsonKey(name: "clouds") final  Clouds clouds;
@override@JsonKey(name: "wind") final  Wind wind;
@override@JsonKey(name: "visibility") final  int visibility;
@override@JsonKey(name: "pop") final  double pop;
@override@JsonKey(name: "rain") final  Rain? rain;
@override@JsonKey(name: "sys") final  Sys sys;
@override@JsonKey(name: "dt_txt") final  DateTime dtTxt;

/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListElementCopyWith<_ListElement> get copyWith => __$ListElementCopyWithImpl<_ListElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListElementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListElement&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other._weather, _weather)&&(identical(other.clouds, clouds) || other.clouds == clouds)&&(identical(other.wind, wind) || other.wind == wind)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.pop, pop) || other.pop == pop)&&(identical(other.rain, rain) || other.rain == rain)&&(identical(other.sys, sys) || other.sys == sys)&&(identical(other.dtTxt, dtTxt) || other.dtTxt == dtTxt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dt,main,const DeepCollectionEquality().hash(_weather),clouds,wind,visibility,pop,rain,sys,dtTxt);

@override
String toString() {
  return 'ListElement(dt: $dt, main: $main, weather: $weather, clouds: $clouds, wind: $wind, visibility: $visibility, pop: $pop, rain: $rain, sys: $sys, dtTxt: $dtTxt)';
}


}

/// @nodoc
abstract mixin class _$ListElementCopyWith<$Res> implements $ListElementCopyWith<$Res> {
  factory _$ListElementCopyWith(_ListElement value, $Res Function(_ListElement) _then) = __$ListElementCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "dt") int dt,@JsonKey(name: "main") MainClass main,@JsonKey(name: "weather") List<Weather> weather,@JsonKey(name: "clouds") Clouds clouds,@JsonKey(name: "wind") Wind wind,@JsonKey(name: "visibility") int visibility,@JsonKey(name: "pop") double pop,@JsonKey(name: "rain") Rain? rain,@JsonKey(name: "sys") Sys sys,@JsonKey(name: "dt_txt") DateTime dtTxt
});


@override $MainClassCopyWith<$Res> get main;@override $CloudsCopyWith<$Res> get clouds;@override $WindCopyWith<$Res> get wind;@override $RainCopyWith<$Res>? get rain;@override $SysCopyWith<$Res> get sys;

}
/// @nodoc
class __$ListElementCopyWithImpl<$Res>
    implements _$ListElementCopyWith<$Res> {
  __$ListElementCopyWithImpl(this._self, this._then);

  final _ListElement _self;
  final $Res Function(_ListElement) _then;

/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dt = null,Object? main = null,Object? weather = null,Object? clouds = null,Object? wind = null,Object? visibility = null,Object? pop = null,Object? rain = freezed,Object? sys = null,Object? dtTxt = null,}) {
  return _then(_ListElement(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as MainClass,weather: null == weather ? _self._weather : weather // ignore: cast_nullable_to_non_nullable
as List<Weather>,clouds: null == clouds ? _self.clouds : clouds // ignore: cast_nullable_to_non_nullable
as Clouds,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as Wind,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as int,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,rain: freezed == rain ? _self.rain : rain // ignore: cast_nullable_to_non_nullable
as Rain?,sys: null == sys ? _self.sys : sys // ignore: cast_nullable_to_non_nullable
as Sys,dtTxt: null == dtTxt ? _self.dtTxt : dtTxt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainClassCopyWith<$Res> get main {
  
  return $MainClassCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudsCopyWith<$Res> get clouds {
  
  return $CloudsCopyWith<$Res>(_self.clouds, (value) {
    return _then(_self.copyWith(clouds: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WindCopyWith<$Res> get wind {
  
  return $WindCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RainCopyWith<$Res>? get rain {
    if (_self.rain == null) {
    return null;
  }

  return $RainCopyWith<$Res>(_self.rain!, (value) {
    return _then(_self.copyWith(rain: value));
  });
}/// Create a copy of ListElement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SysCopyWith<$Res> get sys {
  
  return $SysCopyWith<$Res>(_self.sys, (value) {
    return _then(_self.copyWith(sys: value));
  });
}
}


/// @nodoc
mixin _$Clouds {

@JsonKey(name: "all") int get all;
/// Create a copy of Clouds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudsCopyWith<Clouds> get copyWith => _$CloudsCopyWithImpl<Clouds>(this as Clouds, _$identity);

  /// Serializes this Clouds to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Clouds&&(identical(other.all, all) || other.all == all));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all);

@override
String toString() {
  return 'Clouds(all: $all)';
}


}

/// @nodoc
abstract mixin class $CloudsCopyWith<$Res>  {
  factory $CloudsCopyWith(Clouds value, $Res Function(Clouds) _then) = _$CloudsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "all") int all
});




}
/// @nodoc
class _$CloudsCopyWithImpl<$Res>
    implements $CloudsCopyWith<$Res> {
  _$CloudsCopyWithImpl(this._self, this._then);

  final Clouds _self;
  final $Res Function(Clouds) _then;

/// Create a copy of Clouds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = null,}) {
  return _then(_self.copyWith(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Clouds].
extension CloudsPatterns on Clouds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Clouds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Clouds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Clouds value)  $default,){
final _that = this;
switch (_that) {
case _Clouds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Clouds value)?  $default,){
final _that = this;
switch (_that) {
case _Clouds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "all")  int all)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Clouds() when $default != null:
return $default(_that.all);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "all")  int all)  $default,) {final _that = this;
switch (_that) {
case _Clouds():
return $default(_that.all);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "all")  int all)?  $default,) {final _that = this;
switch (_that) {
case _Clouds() when $default != null:
return $default(_that.all);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Clouds implements Clouds {
  const _Clouds({@JsonKey(name: "all") required this.all});
  factory _Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);

@override@JsonKey(name: "all") final  int all;

/// Create a copy of Clouds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudsCopyWith<_Clouds> get copyWith => __$CloudsCopyWithImpl<_Clouds>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Clouds&&(identical(other.all, all) || other.all == all));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all);

@override
String toString() {
  return 'Clouds(all: $all)';
}


}

/// @nodoc
abstract mixin class _$CloudsCopyWith<$Res> implements $CloudsCopyWith<$Res> {
  factory _$CloudsCopyWith(_Clouds value, $Res Function(_Clouds) _then) = __$CloudsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "all") int all
});




}
/// @nodoc
class __$CloudsCopyWithImpl<$Res>
    implements _$CloudsCopyWith<$Res> {
  __$CloudsCopyWithImpl(this._self, this._then);

  final _Clouds _self;
  final $Res Function(_Clouds) _then;

/// Create a copy of Clouds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,}) {
  return _then(_Clouds(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MainClass {

@JsonKey(name: "temp") double get temp;@JsonKey(name: "feels_like") double get feelsLike;@JsonKey(name: "temp_min") double get tempMin;@JsonKey(name: "temp_max") double get tempMax;@JsonKey(name: "pressure") int get pressure;@JsonKey(name: "sea_level") int? get seaLevel;@JsonKey(name: "grnd_level") int? get grndLevel;@JsonKey(name: "humidity") int get humidity;@JsonKey(name: "temp_kf") double? get tempKf;
/// Create a copy of MainClass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainClassCopyWith<MainClass> get copyWith => _$MainClassCopyWithImpl<MainClass>(this as MainClass, _$identity);

  /// Serializes this MainClass to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainClass&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.seaLevel, seaLevel) || other.seaLevel == seaLevel)&&(identical(other.grndLevel, grndLevel) || other.grndLevel == grndLevel)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.tempKf, tempKf) || other.tempKf == tempKf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temp,feelsLike,tempMin,tempMax,pressure,seaLevel,grndLevel,humidity,tempKf);

@override
String toString() {
  return 'MainClass(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, seaLevel: $seaLevel, grndLevel: $grndLevel, humidity: $humidity, tempKf: $tempKf)';
}


}

/// @nodoc
abstract mixin class $MainClassCopyWith<$Res>  {
  factory $MainClassCopyWith(MainClass value, $Res Function(MainClass) _then) = _$MainClassCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "temp") double temp,@JsonKey(name: "feels_like") double feelsLike,@JsonKey(name: "temp_min") double tempMin,@JsonKey(name: "temp_max") double tempMax,@JsonKey(name: "pressure") int pressure,@JsonKey(name: "sea_level") int? seaLevel,@JsonKey(name: "grnd_level") int? grndLevel,@JsonKey(name: "humidity") int humidity,@JsonKey(name: "temp_kf") double? tempKf
});




}
/// @nodoc
class _$MainClassCopyWithImpl<$Res>
    implements $MainClassCopyWith<$Res> {
  _$MainClassCopyWithImpl(this._self, this._then);

  final MainClass _self;
  final $Res Function(MainClass) _then;

/// Create a copy of MainClass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temp = null,Object? feelsLike = null,Object? tempMin = null,Object? tempMax = null,Object? pressure = null,Object? seaLevel = freezed,Object? grndLevel = freezed,Object? humidity = null,Object? tempKf = freezed,}) {
  return _then(_self.copyWith(
temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,seaLevel: freezed == seaLevel ? _self.seaLevel : seaLevel // ignore: cast_nullable_to_non_nullable
as int?,grndLevel: freezed == grndLevel ? _self.grndLevel : grndLevel // ignore: cast_nullable_to_non_nullable
as int?,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,tempKf: freezed == tempKf ? _self.tempKf : tempKf // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MainClass].
extension MainClassPatterns on MainClass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainClass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainClass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainClass value)  $default,){
final _that = this;
switch (_that) {
case _MainClass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainClass value)?  $default,){
final _that = this;
switch (_that) {
case _MainClass() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "temp")  double temp, @JsonKey(name: "feels_like")  double feelsLike, @JsonKey(name: "temp_min")  double tempMin, @JsonKey(name: "temp_max")  double tempMax, @JsonKey(name: "pressure")  int pressure, @JsonKey(name: "sea_level")  int? seaLevel, @JsonKey(name: "grnd_level")  int? grndLevel, @JsonKey(name: "humidity")  int humidity, @JsonKey(name: "temp_kf")  double? tempKf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainClass() when $default != null:
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.seaLevel,_that.grndLevel,_that.humidity,_that.tempKf);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "temp")  double temp, @JsonKey(name: "feels_like")  double feelsLike, @JsonKey(name: "temp_min")  double tempMin, @JsonKey(name: "temp_max")  double tempMax, @JsonKey(name: "pressure")  int pressure, @JsonKey(name: "sea_level")  int? seaLevel, @JsonKey(name: "grnd_level")  int? grndLevel, @JsonKey(name: "humidity")  int humidity, @JsonKey(name: "temp_kf")  double? tempKf)  $default,) {final _that = this;
switch (_that) {
case _MainClass():
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.seaLevel,_that.grndLevel,_that.humidity,_that.tempKf);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "temp")  double temp, @JsonKey(name: "feels_like")  double feelsLike, @JsonKey(name: "temp_min")  double tempMin, @JsonKey(name: "temp_max")  double tempMax, @JsonKey(name: "pressure")  int pressure, @JsonKey(name: "sea_level")  int? seaLevel, @JsonKey(name: "grnd_level")  int? grndLevel, @JsonKey(name: "humidity")  int humidity, @JsonKey(name: "temp_kf")  double? tempKf)?  $default,) {final _that = this;
switch (_that) {
case _MainClass() when $default != null:
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.seaLevel,_that.grndLevel,_that.humidity,_that.tempKf);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MainClass implements MainClass {
  const _MainClass({@JsonKey(name: "temp") required this.temp, @JsonKey(name: "feels_like") required this.feelsLike, @JsonKey(name: "temp_min") required this.tempMin, @JsonKey(name: "temp_max") required this.tempMax, @JsonKey(name: "pressure") required this.pressure, @JsonKey(name: "sea_level") this.seaLevel, @JsonKey(name: "grnd_level") this.grndLevel, @JsonKey(name: "humidity") required this.humidity, @JsonKey(name: "temp_kf") this.tempKf});
  factory _MainClass.fromJson(Map<String, dynamic> json) => _$MainClassFromJson(json);

@override@JsonKey(name: "temp") final  double temp;
@override@JsonKey(name: "feels_like") final  double feelsLike;
@override@JsonKey(name: "temp_min") final  double tempMin;
@override@JsonKey(name: "temp_max") final  double tempMax;
@override@JsonKey(name: "pressure") final  int pressure;
@override@JsonKey(name: "sea_level") final  int? seaLevel;
@override@JsonKey(name: "grnd_level") final  int? grndLevel;
@override@JsonKey(name: "humidity") final  int humidity;
@override@JsonKey(name: "temp_kf") final  double? tempKf;

/// Create a copy of MainClass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainClassCopyWith<_MainClass> get copyWith => __$MainClassCopyWithImpl<_MainClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MainClassToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainClass&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.seaLevel, seaLevel) || other.seaLevel == seaLevel)&&(identical(other.grndLevel, grndLevel) || other.grndLevel == grndLevel)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.tempKf, tempKf) || other.tempKf == tempKf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temp,feelsLike,tempMin,tempMax,pressure,seaLevel,grndLevel,humidity,tempKf);

@override
String toString() {
  return 'MainClass(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, seaLevel: $seaLevel, grndLevel: $grndLevel, humidity: $humidity, tempKf: $tempKf)';
}


}

/// @nodoc
abstract mixin class _$MainClassCopyWith<$Res> implements $MainClassCopyWith<$Res> {
  factory _$MainClassCopyWith(_MainClass value, $Res Function(_MainClass) _then) = __$MainClassCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "temp") double temp,@JsonKey(name: "feels_like") double feelsLike,@JsonKey(name: "temp_min") double tempMin,@JsonKey(name: "temp_max") double tempMax,@JsonKey(name: "pressure") int pressure,@JsonKey(name: "sea_level") int? seaLevel,@JsonKey(name: "grnd_level") int? grndLevel,@JsonKey(name: "humidity") int humidity,@JsonKey(name: "temp_kf") double? tempKf
});




}
/// @nodoc
class __$MainClassCopyWithImpl<$Res>
    implements _$MainClassCopyWith<$Res> {
  __$MainClassCopyWithImpl(this._self, this._then);

  final _MainClass _self;
  final $Res Function(_MainClass) _then;

/// Create a copy of MainClass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temp = null,Object? feelsLike = null,Object? tempMin = null,Object? tempMax = null,Object? pressure = null,Object? seaLevel = freezed,Object? grndLevel = freezed,Object? humidity = null,Object? tempKf = freezed,}) {
  return _then(_MainClass(
temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,seaLevel: freezed == seaLevel ? _self.seaLevel : seaLevel // ignore: cast_nullable_to_non_nullable
as int?,grndLevel: freezed == grndLevel ? _self.grndLevel : grndLevel // ignore: cast_nullable_to_non_nullable
as int?,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,tempKf: freezed == tempKf ? _self.tempKf : tempKf // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$Rain {

@JsonKey(name: "3h") double get the3H;
/// Create a copy of Rain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RainCopyWith<Rain> get copyWith => _$RainCopyWithImpl<Rain>(this as Rain, _$identity);

  /// Serializes this Rain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rain&&(identical(other.the3H, the3H) || other.the3H == the3H));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,the3H);

@override
String toString() {
  return 'Rain(the3H: $the3H)';
}


}

/// @nodoc
abstract mixin class $RainCopyWith<$Res>  {
  factory $RainCopyWith(Rain value, $Res Function(Rain) _then) = _$RainCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "3h") double the3H
});




}
/// @nodoc
class _$RainCopyWithImpl<$Res>
    implements $RainCopyWith<$Res> {
  _$RainCopyWithImpl(this._self, this._then);

  final Rain _self;
  final $Res Function(Rain) _then;

/// Create a copy of Rain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? the3H = null,}) {
  return _then(_self.copyWith(
the3H: null == the3H ? _self.the3H : the3H // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Rain].
extension RainPatterns on Rain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rain value)  $default,){
final _that = this;
switch (_that) {
case _Rain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rain value)?  $default,){
final _that = this;
switch (_that) {
case _Rain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "3h")  double the3H)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rain() when $default != null:
return $default(_that.the3H);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "3h")  double the3H)  $default,) {final _that = this;
switch (_that) {
case _Rain():
return $default(_that.the3H);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "3h")  double the3H)?  $default,) {final _that = this;
switch (_that) {
case _Rain() when $default != null:
return $default(_that.the3H);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Rain implements Rain {
  const _Rain({@JsonKey(name: "3h") required this.the3H});
  factory _Rain.fromJson(Map<String, dynamic> json) => _$RainFromJson(json);

@override@JsonKey(name: "3h") final  double the3H;

/// Create a copy of Rain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RainCopyWith<_Rain> get copyWith => __$RainCopyWithImpl<_Rain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RainToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rain&&(identical(other.the3H, the3H) || other.the3H == the3H));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,the3H);

@override
String toString() {
  return 'Rain(the3H: $the3H)';
}


}

/// @nodoc
abstract mixin class _$RainCopyWith<$Res> implements $RainCopyWith<$Res> {
  factory _$RainCopyWith(_Rain value, $Res Function(_Rain) _then) = __$RainCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "3h") double the3H
});




}
/// @nodoc
class __$RainCopyWithImpl<$Res>
    implements _$RainCopyWith<$Res> {
  __$RainCopyWithImpl(this._self, this._then);

  final _Rain _self;
  final $Res Function(_Rain) _then;

/// Create a copy of Rain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? the3H = null,}) {
  return _then(_Rain(
the3H: null == the3H ? _self.the3H : the3H // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Sys {

@JsonKey(name: "pod") Pod get pod;
/// Create a copy of Sys
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SysCopyWith<Sys> get copyWith => _$SysCopyWithImpl<Sys>(this as Sys, _$identity);

  /// Serializes this Sys to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sys&&(identical(other.pod, pod) || other.pod == pod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pod);

@override
String toString() {
  return 'Sys(pod: $pod)';
}


}

/// @nodoc
abstract mixin class $SysCopyWith<$Res>  {
  factory $SysCopyWith(Sys value, $Res Function(Sys) _then) = _$SysCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "pod") Pod pod
});




}
/// @nodoc
class _$SysCopyWithImpl<$Res>
    implements $SysCopyWith<$Res> {
  _$SysCopyWithImpl(this._self, this._then);

  final Sys _self;
  final $Res Function(Sys) _then;

/// Create a copy of Sys
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pod = null,}) {
  return _then(_self.copyWith(
pod: null == pod ? _self.pod : pod // ignore: cast_nullable_to_non_nullable
as Pod,
  ));
}

}


/// Adds pattern-matching-related methods to [Sys].
extension SysPatterns on Sys {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sys value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sys() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sys value)  $default,){
final _that = this;
switch (_that) {
case _Sys():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sys value)?  $default,){
final _that = this;
switch (_that) {
case _Sys() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "pod")  Pod pod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sys() when $default != null:
return $default(_that.pod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "pod")  Pod pod)  $default,) {final _that = this;
switch (_that) {
case _Sys():
return $default(_that.pod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "pod")  Pod pod)?  $default,) {final _that = this;
switch (_that) {
case _Sys() when $default != null:
return $default(_that.pod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sys implements Sys {
  const _Sys({@JsonKey(name: "pod") required this.pod});
  factory _Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);

@override@JsonKey(name: "pod") final  Pod pod;

/// Create a copy of Sys
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SysCopyWith<_Sys> get copyWith => __$SysCopyWithImpl<_Sys>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SysToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sys&&(identical(other.pod, pod) || other.pod == pod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pod);

@override
String toString() {
  return 'Sys(pod: $pod)';
}


}

/// @nodoc
abstract mixin class _$SysCopyWith<$Res> implements $SysCopyWith<$Res> {
  factory _$SysCopyWith(_Sys value, $Res Function(_Sys) _then) = __$SysCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "pod") Pod pod
});




}
/// @nodoc
class __$SysCopyWithImpl<$Res>
    implements _$SysCopyWith<$Res> {
  __$SysCopyWithImpl(this._self, this._then);

  final _Sys _self;
  final $Res Function(_Sys) _then;

/// Create a copy of Sys
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pod = null,}) {
  return _then(_Sys(
pod: null == pod ? _self.pod : pod // ignore: cast_nullable_to_non_nullable
as Pod,
  ));
}


}


/// @nodoc
mixin _$Weather {

@JsonKey(name: "id") int get id;@JsonKey(name: "main") String get main;@JsonKey(name: "description") String get description;@JsonKey(name: "icon") String get icon;
/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherCopyWith<Weather> get copyWith => _$WeatherCopyWithImpl<Weather>(this as Weather, _$identity);

  /// Serializes this Weather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Weather&&(identical(other.id, id) || other.id == id)&&(identical(other.main, main) || other.main == main)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,main,description,icon);

@override
String toString() {
  return 'Weather(id: $id, main: $main, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $WeatherCopyWith<$Res>  {
  factory $WeatherCopyWith(Weather value, $Res Function(Weather) _then) = _$WeatherCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "main") String main,@JsonKey(name: "description") String description,@JsonKey(name: "icon") String icon
});




}
/// @nodoc
class _$WeatherCopyWithImpl<$Res>
    implements $WeatherCopyWith<$Res> {
  _$WeatherCopyWithImpl(this._self, this._then);

  final Weather _self;
  final $Res Function(Weather) _then;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? main = null,Object? description = null,Object? icon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Weather].
extension WeatherPatterns on Weather {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Weather value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Weather() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Weather value)  $default,){
final _that = this;
switch (_that) {
case _Weather():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Weather value)?  $default,){
final _that = this;
switch (_that) {
case _Weather() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "main")  String main, @JsonKey(name: "description")  String description, @JsonKey(name: "icon")  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Weather() when $default != null:
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "main")  String main, @JsonKey(name: "description")  String description, @JsonKey(name: "icon")  String icon)  $default,) {final _that = this;
switch (_that) {
case _Weather():
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "main")  String main, @JsonKey(name: "description")  String description, @JsonKey(name: "icon")  String icon)?  $default,) {final _that = this;
switch (_that) {
case _Weather() when $default != null:
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Weather implements Weather {
  const _Weather({@JsonKey(name: "id") required this.id, @JsonKey(name: "main") required this.main, @JsonKey(name: "description") required this.description, @JsonKey(name: "icon") required this.icon});
  factory _Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "main") final  String main;
@override@JsonKey(name: "description") final  String description;
@override@JsonKey(name: "icon") final  String icon;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherCopyWith<_Weather> get copyWith => __$WeatherCopyWithImpl<_Weather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Weather&&(identical(other.id, id) || other.id == id)&&(identical(other.main, main) || other.main == main)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,main,description,icon);

@override
String toString() {
  return 'Weather(id: $id, main: $main, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$WeatherCopyWith<$Res> implements $WeatherCopyWith<$Res> {
  factory _$WeatherCopyWith(_Weather value, $Res Function(_Weather) _then) = __$WeatherCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "main") String main,@JsonKey(name: "description") String description,@JsonKey(name: "icon") String icon
});




}
/// @nodoc
class __$WeatherCopyWithImpl<$Res>
    implements _$WeatherCopyWith<$Res> {
  __$WeatherCopyWithImpl(this._self, this._then);

  final _Weather _self;
  final $Res Function(_Weather) _then;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? main = null,Object? description = null,Object? icon = null,}) {
  return _then(_Weather(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Wind {

@JsonKey(name: "speed") double get speed;@JsonKey(name: "deg") int get deg;@JsonKey(name: "gust") double? get gust;
/// Create a copy of Wind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindCopyWith<Wind> get copyWith => _$WindCopyWithImpl<Wind>(this as Wind, _$identity);

  /// Serializes this Wind to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wind&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.deg, deg) || other.deg == deg)&&(identical(other.gust, gust) || other.gust == gust));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speed,deg,gust);

@override
String toString() {
  return 'Wind(speed: $speed, deg: $deg, gust: $gust)';
}


}

/// @nodoc
abstract mixin class $WindCopyWith<$Res>  {
  factory $WindCopyWith(Wind value, $Res Function(Wind) _then) = _$WindCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "speed") double speed,@JsonKey(name: "deg") int deg,@JsonKey(name: "gust") double? gust
});




}
/// @nodoc
class _$WindCopyWithImpl<$Res>
    implements $WindCopyWith<$Res> {
  _$WindCopyWithImpl(this._self, this._then);

  final Wind _self;
  final $Res Function(Wind) _then;

/// Create a copy of Wind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speed = null,Object? deg = null,Object? gust = freezed,}) {
  return _then(_self.copyWith(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,deg: null == deg ? _self.deg : deg // ignore: cast_nullable_to_non_nullable
as int,gust: freezed == gust ? _self.gust : gust // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Wind].
extension WindPatterns on Wind {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wind value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wind() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wind value)  $default,){
final _that = this;
switch (_that) {
case _Wind():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wind value)?  $default,){
final _that = this;
switch (_that) {
case _Wind() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "speed")  double speed, @JsonKey(name: "deg")  int deg, @JsonKey(name: "gust")  double? gust)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wind() when $default != null:
return $default(_that.speed,_that.deg,_that.gust);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "speed")  double speed, @JsonKey(name: "deg")  int deg, @JsonKey(name: "gust")  double? gust)  $default,) {final _that = this;
switch (_that) {
case _Wind():
return $default(_that.speed,_that.deg,_that.gust);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "speed")  double speed, @JsonKey(name: "deg")  int deg, @JsonKey(name: "gust")  double? gust)?  $default,) {final _that = this;
switch (_that) {
case _Wind() when $default != null:
return $default(_that.speed,_that.deg,_that.gust);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wind implements Wind {
  const _Wind({@JsonKey(name: "speed") required this.speed, @JsonKey(name: "deg") required this.deg, @JsonKey(name: "gust") this.gust});
  factory _Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);

@override@JsonKey(name: "speed") final  double speed;
@override@JsonKey(name: "deg") final  int deg;
@override@JsonKey(name: "gust") final  double? gust;

/// Create a copy of Wind
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WindCopyWith<_Wind> get copyWith => __$WindCopyWithImpl<_Wind>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WindToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wind&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.deg, deg) || other.deg == deg)&&(identical(other.gust, gust) || other.gust == gust));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speed,deg,gust);

@override
String toString() {
  return 'Wind(speed: $speed, deg: $deg, gust: $gust)';
}


}

/// @nodoc
abstract mixin class _$WindCopyWith<$Res> implements $WindCopyWith<$Res> {
  factory _$WindCopyWith(_Wind value, $Res Function(_Wind) _then) = __$WindCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "speed") double speed,@JsonKey(name: "deg") int deg,@JsonKey(name: "gust") double? gust
});




}
/// @nodoc
class __$WindCopyWithImpl<$Res>
    implements _$WindCopyWith<$Res> {
  __$WindCopyWithImpl(this._self, this._then);

  final _Wind _self;
  final $Res Function(_Wind) _then;

/// Create a copy of Wind
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speed = null,Object? deg = null,Object? gust = freezed,}) {
  return _then(_Wind(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,deg: null == deg ? _self.deg : deg // ignore: cast_nullable_to_non_nullable
as int,gust: freezed == gust ? _self.gust : gust // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
