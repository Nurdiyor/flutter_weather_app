import 'package:dio/dio.dart';
import 'package:forecast_project/src/core/utils/my_functions.dart';
import 'package:forecast_project/src/data/dto/base/base_response.dart';
import 'package:forecast_project/src/data/dto/response/weather_response.dart';
import 'package:forecast_project/src/data/network/net_base.dart';

class WeatherServices {
  final NetBase _netBase;

  WeatherServices(this._netBase);

  Future<BaseResponse<WeatherResponse>> getDailyWeather(
      double lat, double lon) async {
    try {
      var response = await _netBase.dio.post(
          'onecall?lat=$lat&lon=$lon&exclude=minutely,hourly&appid=e2e9368b6c67611008134935ada68fdf');
      if (response.statusCode == 200) {
        var auth2Response = WeatherResponse.fromJson(response.data);
        return BaseResponse(success: true, body: auth2Response);
      } else {
        return BaseResponse(success: false, message: "Something went wrong");
      }
    }
    on DioError catch (e) {
      return BaseResponse(
        success: false,
        message: "No internet connection",
      );
    }
    on Exception catch(e){
      return BaseResponse(
        success: false,
        message: "No internet connection",
      );
    }
  }
}
