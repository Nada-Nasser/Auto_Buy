import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_tile.dart';
import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  final double height;
  final List<Product> productsList;
  final bool isHorizontal;

  ProductsListView(
      {Key key,
      this.height,
      @required this.productsList,
      this.isHorizontal = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productsList.isEmpty)
      return Container(
        height: 100,
        child: Center(
          child: Text(
            "No products",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    return Container(
      height: height ?? calcHeight(context),
      child: ListView.builder(
        itemCount: productsList.length,
        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return ProductListTile(
            product: productsList[index],
            onTap: () {
              //  Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ProductInfoScreen.create(
                    context,
                    productsList[index],
                    productsList[index].picturePath,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  double calcHeight(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final scale = isPortrait ? 0.36 : 0.62;
    return scale * MediaQuery.of(context).size.height;
  }
}
