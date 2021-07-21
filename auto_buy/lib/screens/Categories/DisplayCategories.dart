import 'backEnd/MainCategoryWidgets/main_categories_screen.dart';
import 'backEnd/subCategoryWidgets/GetSubCategories.dart';
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
      return mainCategScreen();
  }
}
