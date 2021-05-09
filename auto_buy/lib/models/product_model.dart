import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String categoryID;
  final String description;
  final int numberInStock;
  String picturePath;
  final double price;
  final bool hasDiscount;
  final double priceBeforeDiscount;

  double get discountPercentage => hasDiscount
      ? ((priceBeforeDiscount - price) / priceBeforeDiscount) * 100
      : 0;

  Product({
    @required this.id,
    @required this.name,
    @required this.numberInStock,
    @required this.picturePath,
    @required this.price,
    @required this.categoryID,
    this.brand = 'None',
    this.description = '',
    this.hasDiscount = false,
    this.priceBeforeDiscount,
  }) : assert(priceBeforeDiscount != 0);

  factory Product.fromMap(Map<dynamic, dynamic> value, String id) {
    return Product(
      name: value['name'],
      categoryID: value['category_id'],
      id: id,
      numberInStock: value['number_in_stock'],
      picturePath: value['pic_path'],
      price: value['price'],
      brand: value['brand'],
      description: value['description'],
      hasDiscount: value['has_discount'],
      priceBeforeDiscount: value['price_before_discount'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'category_id': this.categoryID,
      'number_in_stock': this.numberInStock,
      'pic_path': this.picturePath,
      'price': this.price,
      'brand': this.brand,
      'description': this.description,
      'has_discount': this.hasDiscount,
      'price_before_discount': this.priceBeforeDiscount,
    };
  }
}
