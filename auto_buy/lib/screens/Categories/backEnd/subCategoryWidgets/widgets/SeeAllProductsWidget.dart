import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../SelectedCategoryNotifier.dart';

class seeAllProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          "ALL PRODUCTS",
          style: new TextStyle(
            fontSize: 12.0,
          ),
        ),
        trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            iconSize: 15,
            onPressed: () {
              Provider.of<SelectedCategoryNotifier>(context, listen: false)
                  .isALLSELECTED(true);
            }),
      ),
    );
  }
}
