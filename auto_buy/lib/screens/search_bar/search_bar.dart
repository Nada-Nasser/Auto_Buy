import 'package:auto_buy/screens/search_bar/searh_bar_screen.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ProductSearchServices sv = ProductSearchServices();

  @override
  Widget build(BuildContext context) {
    sv.readAllProducts();
    return SearchBarScreen(sv: sv);
  }
}
