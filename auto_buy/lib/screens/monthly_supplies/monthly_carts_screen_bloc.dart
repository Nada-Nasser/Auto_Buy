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

  List<Product> monthlyCartProducts = [];
  List<int> quantities = [];

  Stream<List<String>> get cartNamesStream =>
      _monthlyCartServices.userMonthlyCartsNamesStream(uid);

  StreamController<String> _cartNameStreamController = StreamController();

  void dispose() => _cartNameStreamController.close();

  Stream<String> get selectedCartNameStream => _cartNameStreamController.stream;
  String selectedCartName;

  Future<void> changeSelectedCart(String selectedName) async {
    selectedCartName = selectedName;
    List<MonthlyCartItem> items =
        await _monthlyCartServices.readMonthlyCartProducts(uid, selectedName);

    monthlyCartProducts.clear();
    for (int i = 0; i < items.length; i++) {
      final product =
          await _productsBackendServices.readProduct(items[i].productId);
      monthlyCartProducts.add(product);
    }

    _cartNameStreamController.add(selectedName);
  }

  Future<bool> checkIfMonthlyCartExist(String name) async =>
      await _monthlyCartServices.checkIfMonthlyCartExist(uid, name);

  Future<void> addNewMonthlyCart(String name, DateTime selectedDate) async =>
      await _monthlyCartServices.addNewMonthlyCart(uid, name, selectedDate);
}
