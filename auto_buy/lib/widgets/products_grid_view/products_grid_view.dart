import 'package:auto_buy/models/product_model.dart';
import 'package:flutter/material.dart';

import 'grid_tile.dart';

class ProductsGridView extends StatelessWidget {
  final List<Product> products;
  final List<int> quantities;
  final Function(BuildContext context, Product product) onTap;
  final Function(BuildContext context, Product product) onLongPress;

  const ProductsGridView(
      {Key key,
      @required this.products,
      this.quantities,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.length == 0) {
      return Center(
        child: Container(
          child: Text(
            "You didn't add any products to this cart...",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            crossAxisCount: 2),
        itemBuilder: (_, index) => ProductGridTile(
          product: products[index],
          quantity: quantities[index] ?? 1,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.4,
          onTap: () => onTap(context, products[index]),
          onLongPress: () => onLongPress(context, products[index]),
        ),
        itemCount: products.length,
      ),
    );
  }
}
