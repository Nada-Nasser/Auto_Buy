
import 'package:flutter/material.dart';

BoxDecoration gradientDecoration() => BoxDecoration(
  gradient: LinearGradient(
      colors: [
            const Color(0xFFFF6D00),
            const Color(0xFFFF9100),
            const Color(0xFFFFAB40),
          ],
          begin: const FractionalOffset(1.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: [0.3, 0.5, 1.0],
          tileMode: TileMode.clamp),
    );

BoxDecoration boxDecorationWithBordersAndShadow(Color color) {
  return BoxDecoration(
    border: Border.all(
      color: Colors.black,
      width: 1.55,
    ),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black,
        offset: const Offset(
          0.0,
          0.0,
        ), //Offset
        blurRadius: 2.0,
        spreadRadius: 0.5,
      ),
      BoxShadow(
        color: Colors.white,
        offset: const Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ), //BoxShadow
    ],
  );
}
