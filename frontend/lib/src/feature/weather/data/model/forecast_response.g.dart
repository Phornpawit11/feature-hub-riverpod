// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForecastResponse _$ForecastResponseFromJson(Map<String, dynamic> json) =>
    _ForecastResponse(
      cod: json['cod'] as String,
      message: (json['message'] as num?)?.toInt(),
      cnt: (json['cnt'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => ListElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: City.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastResponseToJson(_ForecastResponse instance) =>
    <String, dynamic>{
      'cod': instance.cod,
      'message': instance.message,
      'cnt': instance.cnt,
      'list': instance.list,
      'city': instance.city,
    };

_City _$CityFromJson(Map<String, dynamic> json) => _City(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  coord: Coord.fromJson(json['coord'] as Map<String, dynamic>),
  country: json['country'] as String,
  population: (json['population'] as num?)?.toInt(),
  timezone: (json['timezone'] as num).toInt(),
  sunrise: (json['sunrise'] as num).toInt(),
  sunset: (json['sunset'] as num).toInt(),
);

Map<String, dynamic> _$CityToJson(_City instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coord': instance.coord,
  'country': instance.country,
  'population': instance.population,
  'timezone': instance.timezone,
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};

_Coord _$CoordFromJson(Map<String, dynamic> json) => _Coord(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$CoordToJson(_Coord instance) => <String, dynamic>{
  'lat': instance.lat,
  'lon': instance.lon,
};

_ListElement _$ListElementFromJson(Map<String, dynamic> json) => _ListElement(
  dt: (json['dt'] as num).toInt(),
  main: MainClass.fromJson(json['main'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => Weather.fromJson(e as Map<String, dynamic>))
      .toList(),
  clouds: Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
  wind: Wind.fromJson(json['wind'] as Map<String, dynamic>),
  visibility: (json['visibility'] as num).toInt(),
  pop: (json['pop'] as num).toDouble(),
  rain: json['rain'] == null
      ? null
      : Rain.fromJson(json['rain'] as Map<String, dynamic>),
  sys: Sys.fromJson(json['sys'] as Map<String, dynamic>),
  dtTxt: DateTime.parse(json['dt_txt'] as String),
);

Map<String, dynamic> _$ListElementToJson(_ListElement instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'clouds': instance.clouds,
      'wind': instance.wind,
      'visibility': instance.visibility,
      'pop': instance.pop,
      'rain': instance.rain,
      'sys': instance.sys,
      'dt_txt': instance.dtTxt.toIso8601String(),
    };

_Clouds _$CloudsFromJson(Map<String, dynamic> json) =>
    _Clouds(all: (json['all'] as num).toInt());

Map<String, dynamic> _$CloudsToJson(_Clouds instance) => <String, dynamic>{
  'all': instance.all,
};

_MainClass _$MainClassFromJson(Map<String, dynamic> json) => _MainClass(
  temp: (json['temp'] as num).toDouble(),
  feelsLike: (json['feels_like'] as num).toDouble(),
  tempMin: (json['temp_min'] as num).toDouble(),
  tempMax: (json['temp_max'] as num).toDouble(),
  pressure: (json['pressure'] as num).toInt(),
  seaLevel: (json['sea_level'] as num?)?.toInt(),
  grndLevel: (json['grnd_level'] as num?)?.toInt(),
  humidity: (json['humidity'] as num).toInt(),
  tempKf: (json['temp_kf'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MainClassToJson(_MainClass instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'temp_min': instance.tempMin,
      'temp_max': instance.tempMax,
      'pressure': instance.pressure,
      'sea_level': instance.seaLevel,
      'grnd_level': instance.grndLevel,
      'humidity': instance.humidity,
      'temp_kf': instance.tempKf,
    };

_Rain _$RainFromJson(Map<String, dynamic> json) =>
    _Rain(the3H: (json['3h'] as num).toDouble());

Map<String, dynamic> _$RainToJson(_Rain instance) => <String, dynamic>{
  '3h': instance.the3H,
};

_Sys _$SysFromJson(Map<String, dynamic> json) =>
    _Sys(pod: $enumDecode(_$PodEnumMap, json['pod']));

Map<String, dynamic> _$SysToJson(_Sys instance) => <String, dynamic>{
  'pod': _$PodEnumMap[instance.pod]!,
};

const _$PodEnumMap = {Pod.D: 'd', Pod.N: 'n'};

_Weather _$WeatherFromJson(Map<String, dynamic> json) => _Weather(
  id: (json['id'] as num).toInt(),
  main: json['main'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$WeatherToJson(_Weather instance) => <String, dynamic>{
  'id': instance.id,
  'main': instance.main,
  'description': instance.description,
  'icon': instance.icon,
};

_Wind _$WindFromJson(Map<String, dynamic> json) => _Wind(
  speed: (json['speed'] as num).toDouble(),
  deg: (json['deg'] as num).toInt(),
  gust: (json['gust'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WindToJson(_Wind instance) => <String, dynamic>{
  'speed': instance.speed,
  'deg': instance.deg,
  'gust': instance.gust,
};
