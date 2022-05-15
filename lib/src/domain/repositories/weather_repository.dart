import 'package:forecast_project/src/data/dto/response/weather_response.dart';
import 'package:forecast_project/src/data/services/hive_service.dart';
import 'package:forecast_project/src/data/services/weather_service.dart';

class WeatherRepository {
  final WeatherServices _netService;
  final HiveService _hiveService;

  WeatherRepository(this._netService, this._hiveService);

  Future<WeatherResponse?> getDailyWeather(double lat, double lon) async {
    var response = await _netService.getDailyWeather(lat, lon);
    if (response.success) {
      _hiveService.putWeather(response.body!);
      return response.body;
    } else {
      var hive = await _hiveService.getWeather(lat, lon);
      return hive;
    }
  }
}
