import 'dart:async';

import 'package:auto_buy/models/monthly_cart_model.dart';
import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/services/monthly_cart_services.dart';

class MonthlyCartsScreenModel {
  List<MonthlyCartModel> monthlyCarts = [];
  Map<String, List<MonthlyCartItem>> monthlyCartsItems = {};

  int get numberOfMonthlyCarts => monthlyCarts.length;
}

class MonthlyCartsBloc {
  final MonthlyCartServices _monthlyCartServices = new MonthlyCartServices();
  final uid;
  MonthlyCartsScreenModel monthlyCartsScreenModel =
      new MonthlyCartsScreenModel();

  MonthlyCartsBloc({this.uid});

  StreamController<MonthlyCartsScreenModel> _streamController =
      StreamController.broadcast();

  dispose() => _streamController.close();

  Stream<MonthlyCartsScreenModel> get stream => _streamController.stream;

  Future<void> fetchUserMonthlyCarts() async {
    monthlyCartsScreenModel.monthlyCarts =
        await _monthlyCartServices.readAllMonthlyCarts(uid);
    for (int i = 0; i < monthlyCartsScreenModel.numberOfMonthlyCarts; i++) {
      print(monthlyCartsScreenModel.monthlyCarts[i].name);
      List<MonthlyCartItem> items =
          await _monthlyCartServices.readMonthlyCartItems(
              uid, monthlyCartsScreenModel.monthlyCarts[i].name);
      monthlyCartsScreenModel.monthlyCartsItems.addAll({
        monthlyCartsScreenModel.monthlyCarts[i].name: items,
      });
    }
    _streamController.sink.add(monthlyCartsScreenModel);
  }

  Future<bool> checkIfMonthlyCartExist(String name) async =>
      await _monthlyCartServices.checkIfMonthlyCartExist(uid, name);

  Future<void> addNewMonthlyCart(String name, DateTime selectedDate) async {
    await _monthlyCartServices.addNewMonthlyCart(uid, name, selectedDate);
    monthlyCartsScreenModel.monthlyCarts
        .add(MonthlyCartModel(name: name, deliveryDate: selectedDate,isCheckedOut: false));
    await fetchUserMonthlyCarts();
  }

  Future<void> editCartDate(String cartName, DateTime selectedDate) async {
    try {
      await _monthlyCartServices.updateDeliveryDateInMonthlyCart(uid, cartName, selectedDate);
      await fetchUserMonthlyCarts();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> setCheckedOut(String cartName , bool val) async {
    try {
      await _monthlyCartServices.setCheckedOut(uid, cartName , val);
      await fetchUserMonthlyCarts();
    } on Exception catch (e) {
      rethrow;
    }
  }
  Future<bool> getChecekOutStat({String cartName,String uid}) async => await _monthlyCartServices.getIsCheckedOut(uid, cartName);

  Future<void> deleteMonthlyCart(String cartName) async {
    try {
      await _monthlyCartServices.deleteMonthlyCart(uid, cartName);
      await fetchUserMonthlyCarts();
    } on Exception catch (e) {
      rethrow;
    }
  }

}
