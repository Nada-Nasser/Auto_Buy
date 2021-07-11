import 'package:flutter/foundation.dart';

class orderModel {
  final Map<String, dynamic> address;
  final DateTime deliveryDate;
  final double price;
  final List<String> productIDs;
  final String userID;
<<<<<<< Updated upstream
  final Map<String,int> productIdsAndQuantity;
=======
  final Map<String, int> productIdsAndQuantity;
  final Map<String, double> productIdsAndPrices;
>>>>>>> Stashed changes

  // newAdress = {"building_number" : bNumberController.text, "city" : cityController.text, "street" : streetController.text, "governorate" : governorate, "apartment_number" : aNumberController.text, "floor_number" : fNumberController.text};

  orderModel(
      {@required this.userID,
      @required this.address,
      @required this.deliveryDate,
      @required this.productIDs,
      @required this.price,
      @required this.productIdsAndQuantity,
      @required this.productIdsAndPrices});

  factory orderModel.fromMap(Map<String, dynamic> values, String id) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        values['delivery_date'].microsecondsSinceEpoch);

    return orderModel(
<<<<<<< Updated upstream
      address: values['address'],
      deliveryDate: date,
      price: values["price"],
      productIDs: values['product_ids'],
      userID: values['user_id'],
      productIdsAndQuantity: values['productid_quantity']
=======
        address: values['address'],
        deliveryDate: DeliveryDate,
        orderDate: OrderDate,
        price: values["price"],
        productIDs: values['product_ids'],
        userID: values['user_id'],
        productIdsAndQuantity: values['productid_quantity'],
        productIdsAndPrices:   values['productid_prices'],
>>>>>>> Stashed changes
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delivery_date': this.deliveryDate,
<<<<<<< Updated upstream
      'address' : this.address,
      'price' : this.price,
      'product_ids' : this.productIDs,
      'user_id' : this.userID,
      'productid_quantity': this.productIdsAndQuantity
=======
      'order_date': this.orderDate,
      'address': this.address,
      'price': this.price,
      'product_ids': this.productIDs,
      'user_id': this.userID,
      'productid_quantity': this.productIdsAndQuantity,
      'productid_prices':this.productIdsAndPrices
>>>>>>> Stashed changes
    };
  }
}
