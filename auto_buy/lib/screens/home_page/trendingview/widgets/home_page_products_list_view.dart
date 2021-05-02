import 'package:auto_buy/screens/home_page/trendingview/widgets/product_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageProductsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 0.4 * MediaQuery.of(context).size.height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ProductListTile(
            imagePath: "assets/images/testing_ads/1.jpg",
            title: "Finish Classic Powder Dishwasher Detergent ",
            price: 200,
          ),
          SizedBox(
            width: 5,
          ),
          ProductListTile(
            imagePath: "assets/images/optioface.png",
            title: "title",
            price: 20,
          ),
          ProductListTile(
            imagePath: "assets/images/optioface.png",
            title: "title",
            price: 20,
          ),
          ProductListTile(
            imagePath: "assets/images/optioface.png",
            title: "title",
            price: 20,
          ),
          ProductListTile(
            imagePath: "assets/images/optioface.png",
            title: "title",
            price: 20,
          ),
          ProductListTile(
            imagePath: "assets/images/optioface.png",
            title: "title",
            price: 20,
          ),
        ],
      ),
    );
  }
}
