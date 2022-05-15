import 'package:flutter/material.dart';

import 'my_functions.dart';

ShapeBorder corneredShapeBorder(double radius) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
}

ShapeBorder corneredShapeBorderSide(Color color, double radius) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: color, width: 1));
}

Decoration corneredDecoration(double radius) {
  return BoxDecoration(
    color: Colors.white,
    // boxShadow: [theme
    //   BoxShadow(
    //     color: Colors.grey,
    //     offset: Offset(0.0, 0.0), //(x,y)
    //     blurRadius: 5.0,
    //   ),
    // ],
    borderRadius: BorderRadius.circular(radius),
  );
}

Decoration coloredCorneredDecoration(String color, double radius) {
  return BoxDecoration(
    color: getColorFromHex(color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Decoration corneredBorderDecoration(
    {required String color, required double radius}) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    border: Border.all(
      color: getColorFromHex(color),
      width: 1.0,
    ),
  );
}
