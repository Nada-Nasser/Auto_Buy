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
          await _monthlyCartServices.readMonthlyCartProducts(
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
        .add(MonthlyCartModel(name: name, deliveryDate: selectedDate));
    await fetchUserMonthlyCarts();
  }

  Future<void> editCartDate(String cartName, DateTime selectedDate) async {
    // TODO: FARAH
    // using uid , cartName , selectedDate, _monthlyCartServices
    // update the delivery_date field in the monthly cart
    await fetchUserMonthlyCarts();
  }

  Future<void> deleteMonthlyCart(String cartName) async {
    // TODO: FARAH
    // using uid , cartName, _monthlyCartServices
    // update the delivery_date field in the monthly cart
    await fetchUserMonthlyCarts();
  }
}
