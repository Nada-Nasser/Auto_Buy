import 'package:auto_buy/screens/Categories/backEnd/GetCategories.dart';
import 'package:auto_buy/screens/Categories/backEnd/SelectedCategoryNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class getSubCategories extends StatefulWidget {
  @override
  _getSubCategoriesState createState() => _getSubCategoriesState();
}

class _getSubCategoriesState extends State<getSubCategories> {
  @override
  Widget build(BuildContext context) {
    print("sub category called");
    final myListener = context.watch<SelectedCategoryNotifier>();
    return Container(
      child: ListView.builder(
        itemCount: GetCategories.categs[myListener.selectedIndex].subcategory.length,
        itemExtent: 70.0,
        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
        itemBuilder: (context, indx){
          return Container(
            child: ListTile(
              dense: true,
              subtitle: Text( GetCategories.categs[myListener.selectedIndex].subcategory[indx]),
            ),
          );
        },
      ),
    );
  }

}

