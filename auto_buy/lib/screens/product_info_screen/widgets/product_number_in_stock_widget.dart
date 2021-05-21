import 'package:flutter/material.dart';

class ProductNumberInStockWidget extends StatelessWidget {
  final int numberInStock;

  const ProductNumberInStockWidget({Key key, this.numberInStock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Center(
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
