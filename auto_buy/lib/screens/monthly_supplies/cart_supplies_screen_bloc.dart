import 'dart:async';

import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/monthly_cart_services.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthlyCartsScreenBloc {
  MonthlyCartsScreenBloc({@required this.uid, this.selectedCartName}) {
    getCartProducts();
  }

  final String uid;
  final MonthlyCartServices _monthlyCartServices = MonthlyCartServices();
  final ProductsBackendServices _productsBackendServices =
      ProductsBackendServices();

  final selectedCartName;
  List<Product> monthlyCartProducts = [];
  List<int> quantities = [];

  StreamController<bool> _streamController = StreamController.broadcast();
  bool reload = false;
  double totalPrice = 0;

  dispose() => _streamController.close();

  Stream<bool> get stream => _streamController.stream;

  Future<void> getCartProducts() async {
    List<MonthlyCartItem> items = await _monthlyCartServices
        .readMonthlyCartProducts(uid, selectedCartName);
    monthlyCartProducts.clear();
    quantities.clear();
    for (int i = 0; i < items.length; i++) {
      quantities.add(items[i].quantity);
      final product =
          await _productsBackendServices.readProduct(items[i].productId);
      monthlyCartProducts.add(product);
    }
    totalPrice = await _monthlyCartServices.getMonthlyCartTotalPrice(
        uid, selectedCartName);
    print("TOTAL PRICE $totalPrice");

    reload = !reload;
    _streamController.add(reload);
  }

  int getProductQuantityInTheCart(String productID) {
    int i;
    for (i = 0; i < monthlyCartProducts.length; i++)
      if (monthlyCartProducts[i].id == productID) break;

    return quantities[i];
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _monthlyCartServices.deleteProductFromMonthlyCart(
          uid, selectedCartName, productId);
      await getCartProducts();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> updateProductQuantityInSelectedMonthlyCart(
      String productId, int q) async {
    try {
      await _monthlyCartServices.updateProductQuantityInMonthlyCart(
          uid, selectedCartName, productId, q);
      await getCartProducts();
    } on Exception catch (e) {
      rethrow;
    }
  }
}
