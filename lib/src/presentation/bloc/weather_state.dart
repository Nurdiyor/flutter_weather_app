// ignore_for_file: must_be_immutable

part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherStateLoadIng extends WeatherInitial {
  bool isLoading;

  WeatherStateLoadIng(this.isLoading);
}

class WeatherStateDailyWeather extends WeatherState {
  WeatherResponse dailyWeather;

  WeatherStateDailyWeather(this.dailyWeather);
}
