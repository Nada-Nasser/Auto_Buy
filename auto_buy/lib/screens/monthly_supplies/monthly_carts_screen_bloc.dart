import 'dart:async';

import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/monthly_cart_services.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:flutter/cupertino.dart';

class MonthlyCartsScreenBloc {
  MonthlyCartsScreenBloc({@required this.uid});

  final String uid;
  final MonthlyCartServices _monthlyCartServices = MonthlyCartServices();
  final ProductsBackendServices _productsBackendServices =
      ProductsBackendServices();

  String selectedCartName;
  List<Product> monthlyCartProducts = [];
  List<int> quantities = [];

  Stream<String> get selectedCartNameStream => _cartNameStreamController.stream;

  Stream<List<String>> get cartNamesStream =>
      _monthlyCartServices.userMonthlyCartsNamesStream(uid);

  StreamController<String> _cartNameStreamController = StreamController();

  void dispose() => _cartNameStreamController.close();

  Future<void> changeSelectedCart(String selectedName) async {
    selectedCartName = selectedName;
    List<MonthlyCartItem> items =
        await _monthlyCartServices.readMonthlyCartProducts(uid, selectedName);

    monthlyCartProducts.clear();
    quantities.clear();
    for (int i = 0; i < items.length; i++) {
      quantities.add(items[i].quantity);
      final product =
          await _productsBackendServices.readProduct(items[i].productId);
      monthlyCartProducts.add(product);
    }

    _cartNameStreamController.add(selectedName);
  }

  int getProductQuantityInTheCart(String productID) {
    int i;
    for (i = 0; i < monthlyCartProducts.length; i++)
      if (monthlyCartProducts[i].id == productID) break;

    return quantities[i];
  }

  Future<bool> checkIfMonthlyCartExist(String name) async =>
      await _monthlyCartServices.checkIfMonthlyCartExist(uid, name);

  Future<void> addNewMonthlyCart(String name, DateTime selectedDate) async =>
      await _monthlyCartServices.addNewMonthlyCart(uid, name, selectedDate);

  Future<void> deleteProduct(String productId) async {
    try {
      await _monthlyCartServices.deleteProductFromMonthlyCart(
          uid, selectedCartName, productId);
      changeSelectedCart(selectedCartName);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> updateProductQuantityInSelectedMonthlyCart(
      String productId, int q) async {
    try {
      await _monthlyCartServices.updateProductQuantityInMonthlyCart(
          uid, selectedCartName, productId, q);
      await changeSelectedCart(selectedCartName);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
