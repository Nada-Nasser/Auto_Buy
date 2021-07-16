import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/search_bar/searh_bar_screen.dart';
import 'package:auto_buy/services/search_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {

  searchServices sv = searchServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: sv.readAllProducts(),
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.hasData)
          return SearchBarScreen(sv: sv,);
        else if (snapshot.hasError)
          return Text("ERROR: ${snapshot.error}");
        else
          return Text('None');

        }
    );
  }
}
