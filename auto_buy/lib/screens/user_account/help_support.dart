import 'package:flutter/material.dart';

class Support extends StatelessWidget {
  final String content = "\n\n\n\n\n\n\n\n\n\nIf you have any suggestions, complains or feedback,\nfeel free to contact us:\n\n";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SelectableText.rich(
        TextSpan(
          text: content,
          style: TextStyle(color: Colors.black, fontSize: 34),
          children: <TextSpan>[
            TextSpan(
                text: 'AutoBuy.Optio@gmail.com',
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue)),
            TextSpan(text: '\n\n\nThanks for giving us the feedback 😊'),
          ],
        ),
        textScaleFactor: 0.5,
        textAlign: TextAlign.center,
      ),
    );
  }
}
