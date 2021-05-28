import 'package:auto_buy/models/product_model.dart';
import 'package:flutter/material.dart';

import 'grid_tile.dart';

class ProductsGridView extends StatelessWidget {
  final List<Product> products;
  final List<int> quantities;
  final int AxisCount;
  final double height;
  final double width;
  final Function(BuildContext context, Product product) onTap;
  final Function(BuildContext context, Product product) onLongPress;

  const ProductsGridView(
      {Key key,
      @required this.products,
      this.AxisCount = 2,
      this.quantities,
      this.onTap,
      this.onLongPress, this.height = 300.0, this.width=200.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: width/ height,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            crossAxisCount: AxisCount),
        itemCount: products.length,
        itemBuilder: (_, index) => ProductGridTile(
          product: products[index],
          quantity:  1,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.4,
          onTap: () => onTap(context, products[index]),
          onLongPress: () => onLongPress(context, products[index]),
        ),
      ),
    );
  }
}
