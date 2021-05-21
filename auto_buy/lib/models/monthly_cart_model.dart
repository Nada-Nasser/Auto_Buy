import 'package:flutter/foundation.dart';

import 'monthly_cart_product_item.dart';

class MonthlyCartModel {
  final String name;
  final List<MonthlyCartItem> items;

  MonthlyCartModel({@required this.name, @required this.items});
}
