import 'package:auto_buy/screens/Categories/backEnd/GetCategories.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:auto_buy/widgets/custom_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayCategories extends StatefulWidget {
  @override
  _DisplayCategoriesState createState() => _DisplayCategoriesState();
}

class _DisplayCategoriesState extends State<DisplayCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              appBar: customAppBar(context),
              body: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Scaffold(
                        body: GetCategories(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(color: Colors.white),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
