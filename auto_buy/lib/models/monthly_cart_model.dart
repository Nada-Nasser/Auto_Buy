import 'package:flutter/foundation.dart';

class MonthlyCartModel {
  final String name;
  final DateTime dateTime;

  MonthlyCartModel({@required this.name, @required this.dateTime});

  factory MonthlyCartModel.fromMap(Map<String, dynamic> values, String id) {
    return MonthlyCartModel(name: id, dateTime: values['delivery_date']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'delivery_date': this.dateTime,
    };
  }
}
