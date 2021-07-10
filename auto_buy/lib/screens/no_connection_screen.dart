import 'package:auto_buy/services/conntections_notifier.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        child: Center(child: Text("There is no internet connection")),
      ),
    );
  }
}
