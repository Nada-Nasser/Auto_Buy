import 'package:flutter/material.dart';

class LoadingImage extends StatelessWidget {
  final double height;

  const LoadingImage({Key key, this.height = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Image.asset(
        "assets/gifs/loading_2.gif",
        fit: BoxFit.fill,
      ),
    );
  }
}
