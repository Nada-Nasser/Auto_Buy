import 'package:flutter/foundation.dart';

class ShoppingCartItem {
  final String productID;
  final DateTime lastModifiedDat;
  final int quantity;
  final double totalPrice;

  ShoppingCartItem({
    @required this.productID,
    @required this.lastModifiedDat,
    @required this.quantity,
    @required this.totalPrice,
  });

  factory ShoppingCartItem.fromMap(Map<String, dynamic> values, String id) {
    return ShoppingCartItem(
      productID: values['product_id'],
      lastModifiedDat: values['last_modified_date'],
      quantity: values['quantity'],
      totalPrice: values['total_price'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': this.productID,
      'last_modified_date': this.lastModifiedDat,
      'quantity': this.quantity,
      'total_price': this.totalPrice
    };
  }
}
