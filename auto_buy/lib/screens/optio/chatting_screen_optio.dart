import 'package:auto_buy/blocs/optio_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {

  @override
  Widget build(BuildContext context) {
    return
      Consumer<OptioChangeNotifier>(
      builder: (context, optioProvider, child) {
        return Flexible(
          child: ListView.builder(
            controller: optioProvider.controller,
            itemCount: optioProvider.chatWidgets.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder(
                child: optioProvider.chatWidgets[index],
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 500),
                builder: (BuildContext context,double _val ,Widget child){
                  return Opacity(
                    opacity: _val,
                    child: Padding(
                      child: child,
                      padding: EdgeInsets.only(bottom: _val*20)
                    )
                  );
                },
              );
            },
          ),
        );
      }
    );
  }
}

