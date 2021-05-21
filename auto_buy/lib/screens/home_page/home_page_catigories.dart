import 'package:flutter/material.dart';

//TODO FARAH
Widget homePageCatigories(BuildContext context){
  return Container(
    height: 100,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          color: Colors.red,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.green,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.blue,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.black,
          width: 100,
          height: 30,
        ),
        Container(
          color: Colors.red,
          width: 100,
          height: 30,
        ),
      ],
    ),
  );
}