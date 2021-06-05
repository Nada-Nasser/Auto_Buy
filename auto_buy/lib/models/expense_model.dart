import 'package:flutter/foundation.dart';

class Expense implements Comparable {
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

  @override
  int compareTo(other) {
    if (this.date == null || other == null) {
      return null;
    }
    if (this.date.isBefore(other)) {
      return 1;
    }
    if (this.date.isAfter(other)) {
      return -1;
    }
    if (this.date.isAtSameMomentAs(other)) {
      return 0;
    }
    return null;
  }
}
