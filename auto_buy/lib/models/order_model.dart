import 'package:flutter/foundation.dart';

class orderModel {
  final Map<String, dynamic> address;
  final DateTime deliveryDate;
  final double price;
  final List<String> productIDs;
  final String userID;
  final Map<String,int> productIdsAndQuantity;

  // newAdress = {"building_number" : bNumberController.text, "city" : cityController.text, "street" : streetController.text, "governorate" : governorate, "apartment_number" : aNumberController.text, "floor_number" : fNumberController.text};

  orderModel(
      {@required this.userID,
      @required this.address,
      @required this.deliveryDate,
      @required this.productIDs,
      @required this.price,
      @required this.productIdsAndQuantity});

  factory orderModel.fromMap(Map<String, dynamic> values, String id) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);

    return orderModel(
      address: values['address'],
      deliveryDate: date,
      price: values["price"],
      productIDs: values['product_ids'],
      userID: values['user_id'],
      productIdsAndQuantity: values['productid_quantity']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delivery_date': this.deliveryDate,
      'address' : this.address,
      'price' : this.price,
      'product_ids' : this.productIDs,
      'user_id' : this.userID,
      'productid_quantity': this.productIdsAndQuantity
    };
  }
}
