import 'package:cached_network_image/cached_network_image.dart';
import "package:charcode/charcode.dart";
import 'package:flutter/material.dart';
import 'package:forecast_project/src/core/utils/constants.dart';
import 'package:forecast_project/src/core/utils/dimensions.dart';
import 'package:forecast_project/src/core/utils/shapes_decorations.dart';
import 'package:forecast_project/src/data/dto/response/weather_response.dart';
import 'package:intl/intl.dart';

class WeatherItem extends StatelessWidget {
  Daily daily;
  VoidCallback onItemClick;

  WeatherItem(this.daily, {required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        margin: EdgeInsets.only(top: margin_padding_16),
        decoration: coloredCorneredDecoration("#E9EDF9", 12),
        padding: EdgeInsets.all(margin_padding_16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(daily.weather![0].main!),
                Text(
                  DateFormat('EEEE').format(
                      DateTime.fromMillisecondsSinceEpoch(daily.dt! * 1000)),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: font_size_24,
                    fontFamily: FontFamily.ABHAYABOLD.name,
                  ),
                ),
                Text(
                  DateFormat('d - MMMM y').format(
                      DateTime.fromMillisecondsSinceEpoch(daily.dt! * 1000)),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: font_size_16,
                    fontFamily: FontFamily.ABHAYAMEDIUM.name,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Container(
              decoration: coloredCorneredDecoration("#B7CAF2", 50),
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl:
                    'http://openweathermap.org/img/wn/${daily.weather![0].icon}.png',
                width: 45,
                height: 45,
              ),
            ),
            SizedBox(
              width: margin_padding_8,
            ),
            Text(
              NumberFormat("###.0").format((daily.feelsLike!.day! - 272.15)) +
                  String.fromCharCode($deg),
              style: TextStyle(
                color: Colors.black,
                fontSize: font_size_24,
                fontFamily: FontFamily.ABHAYABOLD.name,
              ),
            ),
            const Icon(Icons.arrow_right)
          ],
        ),
      ),
    );
  }
}
