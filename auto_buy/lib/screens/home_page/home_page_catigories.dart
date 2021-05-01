import 'package:flutter/material.dart';

Widget homePageCatigories(BuildContext context){
  return Container(
    height: 100,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          color: Colors.orange,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.orange,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.orange,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.orange,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.orange,
          width: 100,
          height: 30,
        ),
      ],
    ),
  );
}