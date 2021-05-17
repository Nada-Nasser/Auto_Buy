import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  // final Product product;
  final String productName;

  //final double productPrice;

  const ProductName({
    Key key,
    this.productName,
    //  this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.6 * MediaQuery.of(context).size.width,
      child: Text(
        productName,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 0.06 * MediaQuery.of(context).size.width,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
