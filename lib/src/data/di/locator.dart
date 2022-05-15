import 'package:forecast_project/src/data/hive/hive_base.dart';
import 'package:forecast_project/src/data/services/hive_service.dart';
import 'package:forecast_project/src/data/network/net_base.dart';
import 'package:forecast_project/src/data/services/weather_service.dart';
import 'package:forecast_project/src/domain/repositories/weather_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

Future<void> setLocator() async {
  locator.registerSingleton(HiveBase());
  await locator.get<HiveBase>().init();
  locator.registerSingleton(HiveService(locator.get()));
  locator.registerSingleton(NetBase());
  locator.registerSingleton(WeatherServices(locator.get()));
  locator.registerSingleton(WeatherRepository(locator.get(), locator.get()));
}
