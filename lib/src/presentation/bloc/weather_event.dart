part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class WeatherEventLoadIng extends WeatherEvent {
  bool isLoading;

  WeatherEventLoadIng(this.isLoading);
}

class WeatherEventDailyWeather extends WeatherEvent {
  City city;

  WeatherEventDailyWeather(this.city);
}
