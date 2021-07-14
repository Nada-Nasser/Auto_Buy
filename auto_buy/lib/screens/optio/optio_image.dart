import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

  Widget optioImage() {
  return Container(
    width: double.infinity,
    height: 300,
    padding: EdgeInsets.all(20),
    child: SvgPicture.asset(
      "assets/images/Optio_body_happy.svg",
    ),
  );
}
