import 'dart:async';

import 'package:auto_buy/models/product_model.dart';
import 'package:flutter/cupertino.dart';

import 'backend/product_info_screen_Services.dart';
import 'backend/product_quantity_and_price_model.dart';

class ProductInfoScreenBloc {
  ProductInfoScreenServices _services = ProductInfoScreenServices();
  final Product product;
  final String uid;

  ProductInfoScreenBloc({@required this.product, @required this.uid});

  Stream<Product> get productOnChangeListener =>
      _services.getProductStream(product.id);

  final StreamController<ProductQuantityAndPriceModel> _modelStreamController =
      StreamController.broadcast();

  ProductQuantityAndPriceModel _model = ProductQuantityAndPriceModel();

  Stream<ProductQuantityAndPriceModel> get modelStream =>
      _modelStreamController.stream;

  int get quantity => _model.quantity;

  String get increasingQuantityErrorMessage =>
      "You cannot buy more than ${product.numberInStock} items";

  bool get isProductInWishList => _model.isProductInWishList;

  void dispose() => _modelStreamController.close();

  double get totalPrice => _model.quantity * product.price;

  Future<void> checkProductInUserWishList() async {
    // update _model with isProductInWishList
    // TODO
  }

  Future<void> _addToWishList() async {
    // TODO
  }

  Future<void> _deleteFromWishList() async {
    // TODO
  }

  Future<void> onClickShoppingCartButton() async {
    // TODO
  }

  Future<String> onClickWishListButton() async {
    try {
      String message = "Something Went Wrong";
      if (_model.isProductInWishList) {
        await _deleteFromWishList();
        message = "Product deleted from your wish list";
      } else {
        await _addToWishList();
        message = "Product added to your wish list";
      }
      _updateModelWith(isProductInWishList: !_model.isProductInWishList);
      return message;
    } on Exception catch (e) {
      throw e;
    }
  }

  bool increaseQuantity() {
    if (_model.quantity < product.numberInStock) {
      _updateModelWith(quantity: _model.quantity + 1);
      return true;
    }
    return false;
  }

  bool decreaseQuantity() {
    if (_model.quantity > 0) {
      _updateModelWith(quantity: _model.quantity - 1);
      return true;
    }
    return false;
  }

  void _updateModelWith({
    int quantity,
    bool isProductInWishList,
    bool isLoading,
  }) {
    _model = _model.copyWith(
      quantity: quantity,
      isProductInWishList: isProductInWishList,
      isLoading: isLoading,
    );
    _modelStreamController.sink.add(_model);
  }
}
