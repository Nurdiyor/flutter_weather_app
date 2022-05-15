import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forecast_project/src/core/utils/dimensions.dart';
import 'package:forecast_project/src/data/di/locator.dart';
import 'package:forecast_project/src/presentation/bloc/weather_bloc.dart';
import 'package:forecast_project/src/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('uz', 'UZ'),
      Locale('ru', 'RU'),
      Locale('en', 'EN'),
    ],
    path: 'assets/lang',
    fallbackLocale: Locale('en', 'EN'),
    saveLocale: true,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          primarySwatch: colorBase,
        ),
        home: const SplashScreen(setUp: setLocator),
      ),
    );
  }
}
