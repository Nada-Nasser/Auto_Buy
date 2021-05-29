import 'package:flutter/foundation.dart';

class MonthlyCartModel {
  final String name;
  final DateTime deliveryDate;

  MonthlyCartModel({@required this.name, @required this.deliveryDate});

  factory MonthlyCartModel.fromMap(Map<String, dynamic> values, String id) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);
    print(date.toString());
    return MonthlyCartModel(name: id, deliveryDate: date);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'delivery_date': this.deliveryDate,
    };
  }
}
