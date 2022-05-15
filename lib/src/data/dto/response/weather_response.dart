class WeatherResponse {
  WeatherResponse({
    double? lat,
    double? lon,
    String? timezone,
    int? timezoneOffset,
    Current? current,
    List<Daily>? daily,
  }) {
    _lat = lat;
    _lon = lon;
    _timezone = timezone;
    _timezoneOffset = timezoneOffset;
    _current = current;
    _daily = daily;
  }

  WeatherResponse.fromJson(dynamic json) {
    _lat = json['lat'];
    _lon = json['lon'];
    _timezone = json['timezone'];
    _timezoneOffset = json['timezone_offset'];
    _current =
        json['current'] != null ? Current.fromJson(json['current']) : null;
    if (json['daily'] != null) {
      _daily = [];
      json['daily'].forEach((v) {
        _daily?.add(Daily.fromJson(v));
      });
    }
  }

  double? _lat;
  double? _lon;
  String? _timezone;
  int? _timezoneOffset;
  Current? _current;
  List<Daily>? _daily;

  double? get lat => _lat;

  double? get lon => _lon;

  String? get timezone => _timezone;

  int? get timezoneOffset => _timezoneOffset;

  Current? get current => _current;

  List<Daily>? get daily => _daily;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lon'] = _lon;
    map['timezone'] = _timezone;
    map['timezone_offset'] = _timezoneOffset;
    if (_current != null) {
      map['current'] = _current?.toJson();
    }
    if (_daily != null) {
      map['daily'] = _daily?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Daily {
  Daily({
    int? dt,
    int? sunrise,
    int? sunset,
    int? moonrise,
    int? moonset,
    double? moonPhase,
    Temp? temp,
    FeelsLike? feelsLike,
    int? pressure,
    int? humidity,
    double? dewPoint,
    double? windSpeed,
    int? windDeg,
    double? windGust,
    List<Weather>? weather,
    int? clouds,
    double? pop,
    double? uvi,
  }) {
    _dt = dt;
    _sunrise = sunrise;
    _sunset = sunset;
    _moonrise = moonrise;
    _moonset = moonset;
    _moonPhase = moonPhase;
    _temp = temp;
    _feelsLike = feelsLike;
    _pressure = pressure;
    _humidity = humidity;
    _dewPoint = dewPoint;
    _windSpeed = windSpeed;
    _windDeg = windDeg;
    _windGust = windGust;
    _weather = weather;
    _clouds = clouds;
    _pop = pop;
    _uvi = uvi;
  }

  Daily.fromJson(dynamic json) {
    _dt = json['dt'];
    _sunrise = json['sunrise'];
    _sunset = json['sunset'];
    _moonrise = json['moonrise'];
    _moonset = json['moonset'];
    _moonPhase = json['moon_phase'];
    _temp = json['temp'] != null ? Temp.fromJson(json['temp']) : null;
    _feelsLike = json['feels_like'] != null
        ? FeelsLike.fromJson(json['feels_like'])
        : null;
    _pressure = json['pressure'];
    _humidity = json['humidity'];
    _dewPoint = double.tryParse(json['dew_point'].toString());
    _windSpeed = json['wind_speed'];
    _windDeg = json['wind_deg'];
    _windGust = json['wind_gust'];
    if (json['weather'] != null) {
      _weather = [];
      json['weather'].forEach((v) {
        _weather?.add(Weather.fromJson(v));
      });
    }
    _clouds = json['clouds'];
    _pop = double.parse(json['pop'].toString());
    _uvi = double.parse(json['uvi'].toString());
  }

  int? _dt;
  int? _sunrise;
  int? _sunset;
  int? _moonrise;
  int? _moonset;
  double? _moonPhase;
  Temp? _temp;
  FeelsLike? _feelsLike;
  int? _pressure;
  int? _humidity;
  double? _dewPoint;
  double? _windSpeed;
  int? _windDeg;
  double? _windGust;
  List<Weather>? _weather;
  int? _clouds;
  double? _pop;
  double? _uvi;

  int? get dt => _dt;

  int? get sunrise => _sunrise;

  int? get sunset => _sunset;

  int? get moonrise => _moonrise;

  int? get moonset => _moonset;

  double? get moonPhase => _moonPhase;

  Temp? get temp => _temp;

  FeelsLike? get feelsLike => _feelsLike;

  int? get pressure => _pressure;

  int? get humidity => _humidity;

  double? get dewPoint => _dewPoint;

  double? get windSpeed => _windSpeed;

  int? get windDeg => _windDeg;

  double? get windGust => _windGust;

  List<Weather>? get weather => _weather;

  int? get clouds => _clouds;

  double? get pop => _pop;

  double? get uvi => _uvi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dt'] = _dt;
    map['sunrise'] = _sunrise;
    map['sunset'] = _sunset;
    map['moonrise'] = _moonrise;
    map['moonset'] = _moonset;
    map['moon_phase'] = _moonPhase;
    if (_temp != null) {
      map['temp'] = _temp?.toJson();
    }
    if (_feelsLike != null) {
      map['feels_like'] = _feelsLike?.toJson();
    }
    map['pressure'] = _pressure;
    map['humidity'] = _humidity;
    map['dew_point'] = _dewPoint;
    map['wind_speed'] = _windSpeed;
    map['wind_deg'] = _windDeg;
    map['wind_gust'] = _windGust;
    if (_weather != null) {
      map['weather'] = _weather?.map((v) => v.toJson()).toList();
    }
    map['clouds'] = _clouds;
    map['pop'] = _pop;
    map['uvi'] = _uvi;
    return map;
  }
}

class Weather {
  Weather({
    int? id,
    String? main,
    String? description,
    String? icon,
  }) {
    _id = id;
    _main = main;
    _description = description;
    _icon = icon;
  }

  Weather.fromJson(dynamic json) {
    _id = json['id'];
    _main = json['main'];
    _description = json['description'];
    _icon = json['icon'];
  }

  int? _id;
  String? _main;
  String? _description;
  String? _icon;

  int? get id => _id;

  String? get main => _main;

  String? get description => _description;

  String? get icon => _icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['main'] = _main;
    map['description'] = _description;
    map['icon'] = _icon;
    return map;
  }
}

class FeelsLike {
  FeelsLike({
    double? day,
    double? night,
    double? eve,
    double? morn,
  }) {
    _day = day;
    _night = night;
    _eve = eve;
    _morn = morn;
  }

  FeelsLike.fromJson(dynamic json) {
    _day = double.parse(json['day'].toString());
    _night = double.parse(json['night'].toString());
    _eve = double.parse(json['eve'].toString());
    _morn = double.parse(json['morn'].toString());
  }

  double? _day;
  double? _night;
  double? _eve;
  double? _morn;

  double? get day => _day;

  double? get night => _night;

  double? get eve => _eve;

  double? get morn => _morn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day'] = _day;
    map['night'] = _night;
    map['eve'] = _eve;
    map['morn'] = _morn;
    return map;
  }
}

class Temp {
  Temp({
    double? day,
    double? min,
    double? max,
    double? night,
    double? eve,
    double? morn,
  }) {
    _day = day;
    _min = min;
    _max = max;
    _night = night;
    _eve = eve;
    _morn = morn;
  }

  Temp.fromJson(dynamic json) {
    _day = double.parse(json['day'].toString());
    _min = double.parse(json['min'].toString());
    _max = double.parse(json['max'].toString());
    _night = double.parse(json['night'].toString());
    _eve = double.parse(json['eve'].toString());
    _morn = double.parse(json['morn'].toString());
  }

  double? _day;
  double? _min;
  double? _max;
  double? _night;
  double? _eve;
  double? _morn;

  double? get day => _day;

  double? get min => _min;

  double? get max => _max;

  double? get night => _night;

  double? get eve => _eve;

  double? get morn => _morn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day'] = _day;
    map['min'] = _min;
    map['max'] = _max;
    map['night'] = _night;
    map['eve'] = _eve;
    map['morn'] = _morn;
    return map;
  }
}

class Current {
  Current({
    int? dt,
    int? sunrise,
    int? sunset,
    double? temp,
    double? feelsLike,
    int? pressure,
    int? humidity,
    double? dewPoint,
    double? uvi,
    int? clouds,
    int? visibility,
    double? windSpeed,
    int? windDeg,
    List<Weather>? weather,
  }) {
    _dt = dt;
    _sunrise = sunrise;
    _sunset = sunset;
    _temp = temp;
    _feelsLike = feelsLike;
    _pressure = pressure;
    _humidity = humidity;
    _dewPoint = dewPoint;
    _uvi = uvi;
    _clouds = clouds;
    _visibility = visibility;
    _windSpeed = windSpeed;
    _windDeg = windDeg;
    _weather = weather;
  }

  Current.fromJson(dynamic json) {
    _dt = json['dt'];
    _sunrise = json['sunrise'];
    _sunset = json['sunset'];
    _temp = double.parse(json['temp'].toString());
    _feelsLike = double.parse(json['feels_like'].toString());
    _pressure = json['pressure'];
    _humidity = json['humidity'];
    _dewPoint = double.parse(json['dew_point'].toString());
    _uvi = double.parse(json['uvi'].toString());
    _clouds = json['clouds'];
    _visibility = json['visibility'];
    _windSpeed = double.parse(json['wind_speed'].toString());
    _windDeg = json['wind_deg'];
    if (json['weather'] != null) {
      _weather = [];
      json['weather'].forEach((v) {
        _weather?.add(Weather.fromJson(v));
      });
    }
  }

  int? _dt;
  int? _sunrise;
  int? _sunset;
  double? _temp;
  double? _feelsLike;
  int? _pressure;
  int? _humidity;
  double? _dewPoint;
  double? _uvi;
  int? _clouds;
  int? _visibility;
  double? _windSpeed;
  int? _windDeg;
  List<Weather>? _weather;

  int? get dt => _dt;

  int? get sunrise => _sunrise;

  int? get sunset => _sunset;

  double? get temp => _temp;

  double? get feelsLike => _feelsLike;

  int? get pressure => _pressure;

  int? get humidity => _humidity;

  double? get dewPoint => _dewPoint;

  double? get uvi => _uvi;

  int? get clouds => _clouds;

  int? get visibility => _visibility;

  double? get windSpeed => _windSpeed;

  int? get windDeg => _windDeg;

  List<Weather>? get weather => _weather;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dt'] = _dt;
    map['sunrise'] = _sunrise;
    map['sunset'] = _sunset;
    map['temp'] = _temp;
    map['feels_like'] = _feelsLike;
    map['pressure'] = _pressure;
    map['humidity'] = _humidity;
    map['dew_point'] = _dewPoint;
    map['uvi'] = _uvi;
    map['clouds'] = _clouds;
    map['visibility'] = _visibility;
    map['wind_speed'] = _windSpeed;
    map['wind_deg'] = _windDeg;
    if (_weather != null) {
      map['weather'] = _weather?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
