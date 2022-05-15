import 'package:cached_network_image/cached_network_image.dart';
import "package:charcode/charcode.dart";
import 'package:flutter/material.dart';
import 'package:forecast_project/src/core/utils/constants.dart';
import 'package:forecast_project/src/core/utils/dimensions.dart';
import 'package:forecast_project/src/core/utils/my_functions.dart';
import 'package:forecast_project/src/core/utils/shapes_decorations.dart';
import 'package:forecast_project/src/data/dto/response/weather_response.dart';
import 'package:forecast_project/src/presentation/screens/main/full_info_weather_item.dart';
import 'package:intl/intl.dart';

class FullInfoScreen extends StatefulWidget {
  String title;
  WeatherResponse weather;

  FullInfoScreen({Key? key, required this.title, required this.weather})
      : super(key: key);

  @override
  State<FullInfoScreen> createState() => _FullInfoScreenState();
}

class _FullInfoScreenState extends State<FullInfoScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: getColorFromHex('#3B68DE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: font_size_24,
            fontFamily: FontFamily.ABHAYAMEDIUM.name,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 86,
            margin: EdgeInsets.only(top: margin_padding_16),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                  bottom: margin_padding_16,
                  left: margin_padding_16,
                  right: margin_padding_16),
              itemCount: widget.weather.daily!.length,
              itemBuilder: (BuildContext context, int index) {
                return FullInfoWeatherItem(
                  currentIndex,
                  widget.weather.daily![index],
                  currentIndex: index,
                  onItemClick: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('d - MMMM y').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.weather.daily![currentIndex].dt! * 1000)),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: font_size_24,
                  fontFamily: FontFamily.ABHAYAMEDIUM.name,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'http://openweathermap.org/img/wn/${widget.weather.daily![currentIndex].weather![0].icon}.png',
                    width: 85,
                    height: 85,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: margin_padding_8,
                  ),
                  Text(
                    NumberFormat("###.0").format((widget
                                .weather.daily![currentIndex].feelsLike!.day! -
                            272.15)) +
                        String.fromCharCode($deg),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 48,
                      fontFamily: FontFamily.ABHAYABOLD.name,
                    ),
                  ),
                ],
              ),
              Text(
                "${widget.weather.daily![currentIndex].weather![0].main}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: font_size_32,
                  fontFamily: FontFamily.ABHAYABOLD.name,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: margin_padding_16,
                left: margin_padding_16,
                right: margin_padding_16),
            child: Row(
              children: [
                Container(
                  decoration: coloredCorneredDecoration("#E9EDF9", 8),
                  width: 120,
                  padding: EdgeInsets.all(margin_padding_8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        getLangString('pressure'),
                        style: TextStyle(
                          color: getColorFromHex('3B68DE'),
                          fontSize: font_size_14,
                          fontFamily: FontFamily.ABHAYAMEDIUM.name,
                        ),
                      ),
                      Text(
                        "${widget.weather.daily![currentIndex].pressure} kPa",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: font_size_24,
                          fontFamily: FontFamily.ABHAYABOLD.name,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: margin_padding_16, right: margin_padding_16),
                  decoration: coloredCorneredDecoration("#E9EDF9", 8),
                  width: 120,
                  padding: EdgeInsets.all(margin_padding_8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        getLangString('humidity'),
                        style: TextStyle(
                          color: getColorFromHex('3B68DE'),
                          fontSize: font_size_14,
                          fontFamily: FontFamily.ABHAYAMEDIUM.name,
                        ),
                      ),
                      Text(
                        "${widget.weather.daily![currentIndex].humidity} %",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: font_size_24,
                          fontFamily: FontFamily.ABHAYABOLD.name,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: coloredCorneredDecoration("#E9EDF9", 8),
                  width: 120,
                  padding: EdgeInsets.all(margin_padding_8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        getLangString('wind_speed'),
                        style: TextStyle(
                          color: getColorFromHex('3B68DE'),
                          fontSize: font_size_14,
                          fontFamily: FontFamily.ABHAYAMEDIUM.name,
                        ),
                      ),
                      Text(
                        "${widget.weather.daily![currentIndex].windSpeed} m/s",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: font_size_24,
                          fontFamily: FontFamily.ABHAYABOLD.name,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
