import 'package:flutter/foundation.dart';

class Expense {
  final DateTime date;
  final double totalPrice;
  final List<String> productsID;
  List<String> productCategoryNames;

  Expense(
      {@required this.date,
      @required this.totalPrice,
      @required this.productsID,
      this.productCategoryNames});

  factory Expense.fromMap(Map<String, dynamic> values, String id) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);
    return Expense(
      date: date,
      totalPrice: double.parse(values['price']),
      productsID: values["product_ids"],
      productCategoryNames: [],
    );
  }
}
