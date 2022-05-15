import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forecast_project/src/core/utils/dimensions.dart';

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
  return Colors.red;
}

void myPrint(dynamic message) {
  if (kDebugMode) {
    print(message);
  }
}
getLangString(String lang) {
  return lang.tr();
}

screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

showLoadingDialog(BuildContext context, {bool isShow = true}) {
  if (isShow) {
    showGeneralDialog(
      context: context,
      // barrierColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.3),
      barrierDismissible: false,
      barrierLabel: "Dialog",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return const SizedBox.expand(
          child: SpinKitDancingSquare(
            size: 150,
            color: colorBase,
          ),
        );
      },
    );
  } else {
    Navigator.pop(context);
  }
}

Widget BaseLoader(BuildContext context) {
  return Container(
    height: screenHeight(context),
    width: screenWidth(context),
    color: Colors.transparent,
    child: const SizedBox.expand(
      child: SpinKitDancingSquare(
        size: 150,
        color: colorBase,
      ),
    ),
  );
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colorBase,
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: font_size_14,
          fontFamily: "PoppinsBold",
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

// TextField(
// decoration: InputDecoration(
// border: InputBorder.none,
// hintText: 'What do you want to remember?'),
// ),
