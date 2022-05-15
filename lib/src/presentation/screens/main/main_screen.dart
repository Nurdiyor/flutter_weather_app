import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import "package:charcode/charcode.dart";
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast_project/src/core/navigation/custom_navigation.dart';
import 'package:forecast_project/src/core/utils/constants.dart';
import 'package:forecast_project/src/core/utils/dimensions.dart';
import 'package:forecast_project/src/core/utils/my_functions.dart';
import 'package:forecast_project/src/core/utils/shapes_decorations.dart';
import 'package:forecast_project/src/domain/models/city.dart';
import 'package:forecast_project/src/presentation/bloc/weather_bloc.dart';
import 'package:forecast_project/src/presentation/screens/main/full_info_screen.dart';
import 'package:forecast_project/src/presentation/screens/main/weather_item.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedCityName = "";
  var cities = [
    City("Tashkent", 41.2646, 69.2163),
    City("Navai", 40.0844, 65.3792),
    City("Fergana", 40.3769, 71.7876),
    City("Bukhara", 41.2646, 69.2163),
    City("Samarkand", 41.2646, 69.2163),
    City("Jizzax", 41.2646, 69.2163),
    City("Syrdarya", 41.2646, 69.2163),
  ];
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: cities.length, vsync: this, initialIndex: 0);
    selectedCityName = cities[0].name;
    getWeather(cities[0]);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if(result==ConnectivityResult.none){
      showSnackBar(context, "Offline Mode");
    }else{
      showSnackBar(context, "Online Mode");
    }
  }
  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: getColorFromHex('#3B68DE'),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: font_size_14,
            fontFamily: FontFamily.ABHAYABOLD.name,
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex('#3B68DE'),
      appBar: AppBar(
        backgroundColor: getColorFromHex('#3B68DE'),
        elevation: 0,
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: margin_padding_16),
              child: Icon(
                Icons.language,
                color: Colors.white,
              ),
            ),
            onTap: () {
              showLangDialog(context);
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: font_size_20,
            fontFamily: FontFamily.ABHAYAEXTRABOLD.name,
          ),
          onTap: (index) {
            myPrint(cities[index].name);
            selectedCityName = cities[index].name;
            getWeather(cities[index]);
          },
          physics: const BouncingScrollPhysics(),
          indicatorPadding: const EdgeInsets.all(5),
          isScrollable: true,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          labelColor: getColorFromHex('#3B68DE'),
          unselectedLabelColor: Colors.white,
          tabs: cities
              .map(
                (e) => Tab(
                  text: e.name,
                ),
              )
              .toList(),
        ),
        title: Text(
          getLangString('weather'),
          style: TextStyle(
            color: Colors.white,
            fontSize: font_size_24,
            fontFamily: FontFamily.ABHAYAMEDIUM.name,
          ),
        ),
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {},
        builder: (BuildContext context, WeatherState state) {
          if (state is WeatherStateLoadIng) {
            return state.isLoading
                ? Container(
                    color: getColorFromHex('#3B68DE'),
                    child: BaseLoader(context),
                  )
                : Container(
                    height: screenHeight(context),
                    width: screenWidth(context),
                    color: getColorFromHex('#3B68DE'),
                    child: Center(
                      child: Text(
                        "No data",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: font_size_36,
                          fontFamily: FontFamily.ABHAYAMEDIUM.name,
                        ),
                      ),
                    ),
                  );
          } else if (state is WeatherStateDailyWeather) {
            return Stack(
              children: [
                SizedBox(
                  height: screenHeight(context) / 2.8,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('d - MMMM y').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  state.dailyWeather.current!.dt! * 1000)),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: font_size_24,
                            fontFamily: FontFamily.ABHAYAMEDIUM.name,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'http://openweathermap.org/img/wn/${state.dailyWeather.current!.weather![0].icon}.png',
                              width: 85,
                              height: 85,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: margin_padding_8,
                            ),
                            Text(
                              NumberFormat("###.0").format(
                                      (state.dailyWeather.current!.feelsLike! -
                                          272.15)) +
                                  String.fromCharCode($deg),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontFamily: FontFamily.ABHAYABOLD.name,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${state.dailyWeather.current!.weather![0].main}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: font_size_32,
                            fontFamily: FontFamily.ABHAYABOLD.name,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openScreenSwipe(
                              context,
                              FullInfoScreen(
                                title: selectedCityName,
                                weather: state.dailyWeather,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: margin_padding_16),
                            padding: EdgeInsets.only(
                                top: margin_padding_4,
                                bottom: margin_padding_4,
                                left: margin_padding_32,
                                right: margin_padding_32),
                            decoration: corneredBorderDecoration(
                                color: "#ffffff", radius: 30),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  getLangString('see_details'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: font_size_14,
                                    fontFamily: FontFamily.ABHAYABOLD.name,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return DraggableScrollableSheet(
                    expand: true,
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        child: Stack(
                          children: [
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              controller: scrollController,
                              padding: EdgeInsets.only(
                                  top: margin_padding_24,
                                  bottom: margin_padding_16,
                                  left: margin_padding_16,
                                  right: margin_padding_16),
                              itemCount: state.dailyWeather.daily!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return WeatherItem(
                                  state.dailyWeather.daily![index],
                                  onItemClick: () {},
                                );
                              },
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(top: margin_padding_16),
                                width: 120,
                                height: 6,
                                decoration:
                                    coloredCorneredDecoration("#DDDDDD", 15),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          } else {
            return Container(
              height: screenHeight(context),
              width: screenWidth(context),
              color: getColorFromHex('#3B68DE'),
            );
          }
        },
      ),
    );
  }

  showLangDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Container(
          height: 200,
          margin: EdgeInsets.only(
              left: margin_padding_16,
              right: margin_padding_16,
              top: margin_padding_16),
          child: Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: EdgeInsets.all(0),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Container(
                padding: EdgeInsets.all(margin_padding_16),
                child: Column(
                  children: [
                    Icon(Icons.language),
                    SizedBox(
                      width: margin_padding_16,
                    ),
                    Expanded(
                      child: Text(
                        getLangString('language'),
                        style: TextStyle(
                          fontSize: font_size_32,
                          fontFamily: FontFamily.ABHAYAREGULAR.name,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            closeActiveScreen(context);
                            setLanguage(Locale('uz', 'UZ'));
                          },
                          child: Text(
                            "Uz",
                            style: TextStyle(
                              fontSize: font_size_32,
                              fontFamily: FontFamily.ABHAYAREGULAR.name,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: margin_padding_16,
                        ),
                        GestureDetector(
                          onTap: () {
                            closeActiveScreen(context);
                            setLanguage(Locale('ru', 'RU'));
                          },
                          child: Text(
                            "Ru",
                            style: TextStyle(
                              fontSize: font_size_32,
                              fontFamily: FontFamily.ABHAYAREGULAR.name,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: margin_padding_16,
                        ),
                        GestureDetector(
                          onTap: () {
                            closeActiveScreen(context);
                            setLanguage(Locale('en', 'EN'));
                          },
                          child: Text(
                            "Eng",
                            style: TextStyle(
                              fontSize: font_size_32,
                              fontFamily: FontFamily.ABHAYAREGULAR.name,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> setLanguage(Locale locale) async {
    await context.setLocale(locale);
  }

  void getWeather(City city) {
    BlocProvider.of<WeatherBloc>(context).add(WeatherEventDailyWeather(city));
  }
  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
