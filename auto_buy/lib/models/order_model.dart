 import 'package:flutter/foundation.dart';

class orderModel {
  final Map<String, dynamic> address;
  final DateTime deliveryDate;
  final DateTime orderDate ;
  final String status;
  final double price;
  final List<String> productIDs;
  final String userID;
  final Map<String, int> productIdsAndQuantity;
  final Map<String, double> productIdsAndPrices;

  // newAdress = {"building_number" : bNumberController.text, "city" : cityController.text, "street" : streetController.text, "governorate" : governorate, "apartment_number" : aNumberController.text, "floor_number" : fNumberController.text};

  orderModel(
      {@required this.userID,
      @required this.address,
      @required this.deliveryDate, this.orderDate,
      @required this.productIDs,
      @required this.price,
      @required this.productIdsAndQuantity,
      @required this.productIdsAndPrices, this.status
      });

  factory orderModel.fromMap(Map<String, dynamic> values, String id) {
    DateTime DeliveryDate = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);
    DateTime OrderDate = DateTime.fromMicrosecondsSinceEpoch(
        values['order_date'].microsecondsSinceEpoch);

    return orderModel(
        address: values['address'],
        deliveryDate: DeliveryDate,
        orderDate: OrderDate,
        status: "pending",
        price: values["price"],
        productIDs: values['product_ids'],
        userID: values['user_id'],
        productIdsAndQuantity: values['productid_quantity'],
        productIdsAndPrices:   values['productid_prices']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delivery_date': this.deliveryDate,
      'order_date': this.orderDate,
      'address': this.address,
      'price': this.price,
      'product_ids': this.productIDs,
      'user_id': this.userID,
      'status' : this.status,
      'productid_quantity': this.productIdsAndQuantity,
      'productid_prices': this.productIdsAndPrices,
    };
  }
}
