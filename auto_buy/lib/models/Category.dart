import 'package:flutter/foundation.dart';

class category{
  final String name;
  final List<dynamic> subcategory;

  category({@required this.name, @required this.subcategory});

  factory category.fromMap(Map<String, dynamic> values, String id) {
    return category(
      name: id,
      subcategory: values['sub_categories'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sub_categories': this.name,
    };
  }
}