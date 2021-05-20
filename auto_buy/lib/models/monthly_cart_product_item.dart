import 'package:flutter/foundation.dart';

class MonthlyCartItem {
  final String productId;
  final int quantity;

  MonthlyCartItem({@required this.productId, @required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
    };
  }

  factory MonthlyCartItem.fromMap(Map<String, dynamic> values, String id) {
    return MonthlyCartItem(
      quantity: values['quantity'],
      productId: id,
    );
  }
}
