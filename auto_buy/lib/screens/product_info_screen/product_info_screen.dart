import 'package:auto_buy/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductInfoScreen extends StatelessWidget {
  final Product product;

  const ProductInfoScreen({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Container(),
    );
  }
}
