import 'package:auto_buy/blocs/optio_change_notifier.dart';
import 'package:auto_buy/screens/optio/text_input_optio.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/widgets/optio_help.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatting_screen_optio.dart';

class OptioScreen extends StatefulWidget {
  final ProductSearchServices searchService;

  const OptioScreen({Key key, this.searchService}) : super(key: key);

  @override
  _OptioScreenState createState() => _OptioScreenState();
}

class _OptioScreenState extends State<OptioScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => OptioChangeNotifier(auth.uid, widget.searchService),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.orange,
              ),
              onPressed: () {
                Navigator.of(context).pop(context);
              }),
          actions: [
            IconButton(icon: Icon(Icons.help), onPressed: () async {
              await optioHelpWidget(context);
            }, color: Colors.orange,)
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
