import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_tile.dart';
import 'package:flutter/material.dart';

class ProductsGridView extends StatelessWidget {
  final List<Product> products;

  const ProductsGridView({Key key, @required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 5 *
              MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.width * 9.0),
        ),
        itemBuilder: (_, index) => ProductListTile(
          product: products[index],
        ),
        itemCount: products.length,
      ),
    );
  }
}
