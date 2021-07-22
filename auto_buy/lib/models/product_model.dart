import 'package:flutter/foundation.dart';

class Product implements Comparable {
  final String id;
  final String name;
  final String brand;
  final String categoryID;
  final String description;
  final int numberInStock;
  String picturePath;
  final double price;
  final bool hasDiscount;
  final double priceAfterDiscount;
  final String subCategory;
  final double size;
  final String sizeUnit;
  final int maxDemandPerUser;
  final int numberSold;

  static String get numberInStockFieldName => "number_in_stock";

  double get discountPercentage =>
      hasDiscount ? ((price - priceAfterDiscount) / price) * 100 : 0;

  Product({
    @required this.id,
    @required this.name,
    @required this.numberInStock,
    @required this.picturePath,
    @required this.price,
    @required this.categoryID,
    @required this.maxDemandPerUser,
    this.numberSold,
    this.brand = 'None',
    this.description = '',
    this.hasDiscount = false,
    this.priceAfterDiscount,
    this.subCategory = "",
    this.size = 0,
    this.sizeUnit = "",
  }) : assert(price != 0 && price != null);

  factory Product.fromMap(Map<String, dynamic> value, String id) {
    return Product(
      id: id,
      name: value['name'],
      numberInStock: value['number_in_stock'],
      picturePath: value['pic_path'],
      price: double.parse('${value['price']}'),
      categoryID: value['category_id'],
      brand: value['brand'] ?? "",
      description: value['description'] ?? "",
      hasDiscount: value['has_discount'] ?? false,
      priceAfterDiscount: value['price_after_discount'] != null
          ? double.parse('${value['price_after_discount']}')
          : null,
      size: value['size'] != null ? double.parse("${value['size']}") : null,
      sizeUnit: value['size_unit'] ?? "",
      subCategory: value['sub_category'] ?? "",
      maxDemandPerUser: int.parse('${value['max_demand_per_user']}'),
      numberSold: value['number_sold'] ?? 0
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
      'price_after_discount': this.priceAfterDiscount,
      'size': this.size,
      'size_unit': this.sizeUnit,
      'sub_category': this.subCategory,
      'max_demand_per_user': this.maxDemandPerUser,
      'number_sold': this.numberSold
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, brand: $brand, categoryID: $categoryID, description: $description, numberInStock: $numberInStock, picturePath: $picturePath, price: $price, hasDiscount: $hasDiscount, priceBeforeDiscount: $priceAfterDiscount, subCategory: $subCategory, size: $size, sizeUnit: $sizeUnit}';
  }

  @override
  int compareTo(other) {
    if (this.numberSold == null || other.numberSold == null) {
      return null;
    }
    if (this.numberSold < other.numberSold) {
      return -1;
    }
    if (this.numberSold > other.numberSold) {
      return 1;
    }
    if (this.numberSold == other.numberSold) {
      return 0;
    }
    return null;
  }
}
