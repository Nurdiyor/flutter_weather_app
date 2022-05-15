import 'package:cached_network_image/cached_network_image.dart';
import "package:charcode/charcode.dart";
import 'package:flutter/material.dart';
import 'package:forecast_project/src/core/utils/constants.dart';
import 'package:forecast_project/src/core/utils/dimensions.dart';
import 'package:forecast_project/src/core/utils/shapes_decorations.dart';
import 'package:forecast_project/src/data/dto/response/weather_response.dart';
import 'package:intl/intl.dart';

class FullInfoWeatherItem extends StatelessWidget {
  Daily daily;
  VoidCallback onItemClick;
  int currentIndex;
  int selectedIndex;
  FullInfoWeatherItem(this.selectedIndex,this.daily, {required this.currentIndex,required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        margin: EdgeInsets.only(right: margin_padding_16),
        decoration: coloredCorneredDecoration(currentIndex==selectedIndex?"#3B68DE":"#E9EDF9", 8),
        padding: EdgeInsets.all(margin_padding_8),
        child: Column(
          children: [
            Text(
              DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(daily.dt! * 1000)),
              style: TextStyle(
                color: currentIndex==selectedIndex?Colors.white:Colors.black,
                fontSize: font_size_12,
                fontFamily: FontFamily.ABHAYAREGULAR.name,
              ),
            ),
            CachedNetworkImage(
              imageUrl:
              'http://openweathermap.org/img/wn/${daily.weather![0].icon}.png',
              width: 24,
              height: 24,
            ),
            SizedBox(
              width: margin_padding_8,
            ),
            Text(
              NumberFormat("###.0").format((daily.feelsLike!.day! - 272.15)) +
                  String.fromCharCode($deg),
              style: TextStyle(
                color: currentIndex==selectedIndex?Colors.white:Colors.black,
                fontSize: font_size_12,
                fontFamily: FontFamily.ABHAYAREGULAR.name,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
