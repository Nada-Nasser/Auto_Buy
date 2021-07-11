import 'package:flutter/foundation.dart';

class Expense implements Comparable {
  final DateTime date;
  final double totalPrice;
  final List<dynamic> productsID;
  List<String> productCategoryNames;
  List<double> productsPrices;
  final Map<String, dynamic> quantities;

  Map<String, double> categoryAndPrice = {};

  Expense(
      {@required this.quantities,
      @required this.date,
      @required this.totalPrice,
      @required this.productsID,
      this.productCategoryNames,
      this.productsPrices,
      this.categoryAndPrice});

  factory Expense.fromMap(Map<String, dynamic> values, String id) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);
    return Expense(
      date: date,
      totalPrice: double.parse('${values['price']}'),
      productsID: values["product_ids"],
      productCategoryNames: [],
      productsPrices: [],
      categoryAndPrice: {},
      quantities: values['productid_quantity'],
    );
  }

  @override
  int compareTo(other) {
    if (this.date == null || other == null) {
      return null;
    }
    if (this.date.isBefore(other.date)) {
      return -1;
    }
    if (this.date.isAfter(other.date)) {
      return 1;
    }
    if (this.date.isAtSameMomentAs(other.date)) {
      return 0;
    }
    return null;
  }

  @override
  String toString() {
    return 'Expense{date: $date, totalPrice: $totalPrice, productsID: $productsID, productCategoryNames: $productCategoryNames}';
  }
}