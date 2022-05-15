import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forecast_project/src/core/navigation/custom_navigation.dart';
import 'package:forecast_project/src/presentation/screens/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  final Function() setUp;

  const SplashScreen({Key? key, required this.setUp}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTime(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Image.asset('assets/weather.jpg'),
        ),
      ),
    );
  }

  startTime(BuildContext context) async {
    await widget.setUp();
    Timer(const Duration(seconds: 2), () {
      openMainScreen(context, MainScreen());
    });
  }
}
