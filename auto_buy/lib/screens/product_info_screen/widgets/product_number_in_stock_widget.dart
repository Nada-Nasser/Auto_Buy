import 'package:flutter/material.dart';

class ProductNumberInStockWidget extends StatelessWidget {
  final int numberInStock;

  const ProductNumberInStockWidget({Key key, this.numberInStock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text(
          "$numberInStock piece(s) left in stock",
          style: TextStyle(
            color: Colors.red[900],
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
