import 'package:forecast_project/src/data/dto/response/weather_response.dart';

import '../hive/hive_base.dart';

class HiveService {
  final HiveBase _hiveBase;

  const HiveService(this._hiveBase);

  Future<void> putWeather(WeatherResponse model) async {
    await _hiveBase.box.put("${model.lat}-${model.lon}", model.toJson());
  }

  Future<WeatherResponse?> getWeather(double lat, double lon) async {
    final model = await _hiveBase.box.get("$lat-$lon");
    if (model != null) {
      return WeatherResponse.fromJson(model);
    } else {
      return null;
    }
  }
}
