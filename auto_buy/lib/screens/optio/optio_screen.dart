import 'package:auto_buy/blocs/optio_change_notifier.dart';
import 'package:auto_buy/screens/optio/text_input_optio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'chatting_screen_optio.dart';

class OptioScreen extends StatefulWidget {
  @override
  _OptioScreenState createState() => _OptioScreenState();
}


class _OptioScreenState extends State<OptioScreen> {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => OptioChangeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.home, color: Colors.orange,),
              onPressed: () {
                Navigator.of(context).pop(context);
              }),
          actions: [
            IconButton(icon: Icon(Icons.help), onPressed: (){}, color: Colors.orange,)
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChattingScreen(),
              TextInputOptio(),
            ],
          ),
        ),
      ),
    );
  }
}