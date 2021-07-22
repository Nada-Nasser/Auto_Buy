import 'backEnd/MainCategoryWidgets/main_categories_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayCategories extends StatefulWidget {
  @override
  _DisplayCategoriesState createState() => _DisplayCategoriesState();
}

class _DisplayCategoriesState extends State<DisplayCategories> {
  @override
  Widget build(BuildContext context) {
      return mainCategoriesScreen();
  }
}
