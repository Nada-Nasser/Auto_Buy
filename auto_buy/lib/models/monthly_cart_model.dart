import 'package:flutter/foundation.dart';

class MonthlyCartModel {
  final String name;
  final DateTime deliveryDate;
  final bool isCheckedOut;

  MonthlyCartModel({@required this.name, @required this.deliveryDate, @required this.isCheckedOut});

  factory MonthlyCartModel.fromMap(Map<String, dynamic> values, String id) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);
    print(date.toString());
    return MonthlyCartModel(name: id, deliveryDate: date, isCheckedOut: values['is_checkedout'] ?? false );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'delivery_date': this.deliveryDate,
      'is_checkedout' : this.isCheckedOut ?? false
    };
  }
}
