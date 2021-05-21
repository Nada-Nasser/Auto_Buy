import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  final String productName;
  const ProductName({
    Key key,
    this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.64 * MediaQuery.of(context).size.width,
      child: Text(
        productName,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 0.05 * MediaQuery.of(context).size.width,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
