import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/product_list_tile.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageProductsListView extends StatelessWidget {
  final List<Product> productsList;

  const HomePageProductsListView({Key key, @required this.productsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final scale = isPortrait ? 0.36 : 0.62;
    final height = scale * MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: productsList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return ProductListTile(
            product: productsList[index],
            onTap: () {
              //Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ProductInfoScreen(
                    product: productsList[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
