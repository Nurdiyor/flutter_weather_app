import 'package:bloc/bloc.dart';
import 'package:forecast_project/src/data/di/locator.dart';
import 'package:forecast_project/src/data/dto/response/weather_response.dart';
import 'package:forecast_project/src/domain/models/city.dart';
import 'package:forecast_project/src/domain/repositories/weather_repository.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository = locator.get();

  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      if (event is WeatherEventDailyWeather) {
        emit.call(WeatherStateLoadIng(true));
        var weather = await repository.getDailyWeather(event.city.lat, event.city.lon);
        emit.call(WeatherStateLoadIng(false));
        if (weather != null) {
          emit.call(WeatherStateDailyWeather(weather));
        }
      }
    });
  }
}
