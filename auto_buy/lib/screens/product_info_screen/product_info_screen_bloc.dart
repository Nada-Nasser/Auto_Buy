import 'dart:async';

import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';
import 'package:flutter/cupertino.dart';

import 'backend/product_info_screen_Services.dart';
import 'backend/product_quantity_and_price_model.dart';

class ProductInfoScreenBloc {
  ProductInfoScreenServices _services = ProductInfoScreenServices();
  Product product;
  final String uid;

  // List<int> _productCostumerRatesModel = [];

  ProductInfoScreenBloc({@required this.product, @required this.uid});

  Stream<Product> get productOnChangeStream =>
      _services.getProductStream(product.id);

  final StreamController<ProductQuantityAndPriceModel> _modelStreamController =
      StreamController.broadcast();

  ProductQuantityAndPriceModel _productQuantityAndPriceModel =
      ProductQuantityAndPriceModel();

  Stream<ProductQuantityAndPriceModel> get productQuantityAndPriceModelStream =>
      _modelStreamController.stream;

  final StreamController<List<int>> _ratesStreamController =
      StreamController.broadcast();

  Stream<List<int>> get ratesStream => _ratesStreamController.stream;

  int get quantity => _productQuantityAndPriceModel.quantity;

  String get increasingQuantityErrorMessage => product.numberInStock > 0
      ? "You cannot buy more than ${product.numberInStock} items"
      : "The product is out of stock for now";

  bool get isProductInWishList =>
      _productQuantityAndPriceModel.isProductInWishList;

  void disposeQuantityAndPriceModelStream() => _modelStreamController.close();

  void disposeRatesStream() => _ratesStreamController.close();

  double get totalPrice =>
      _productQuantityAndPriceModel.quantity * product.price;

  Future<void> checkProductInUserWishList() async {
    bool exists = await _services.checkProductInWishList(uid, product.id);
    print(exists);
    _updateModelWith(isProductInWishList: exists);
  }

  Future<void> _addToWishList() async {
    await _services.addProductToUserWishList(uid, product.id);
    _updateModelWith(isProductInWishList: true);
  }

  Future<void> _deleteFromWishList() async {
    await _services.deleteProductToUserWishList(uid, product.id);
    _updateModelWith(isProductInWishList: false);
  }

  Future<String> onClickShoppingCartButton() async {
    if (product.numberInStock == 0) return "The product is out of stock";
    try {
      if (quantity > 0 && quantity <= product.numberInStock) {
        final cartItem = ShoppingCartItem(
          productID: product.id,
          totalPrice: totalPrice,
          quantity: quantity,
          lastModifiedDat: DateTime.now(),
        );

        await _services.addProductToUserShopping(
            uid, cartItem, product.numberInStock);

        _updateModelWith(quantity: 0);

        return "Product added to your shopping cart";
      } else {
        if (quantity == 0)
          return "You can not add 0 items";
        else
          return "You can't buy more than ${product.numberInStock}";
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<String> onClickWishListButton() async {
    try {
      String message = "Something Went Wrong";
      if (_productQuantityAndPriceModel.isProductInWishList) {
        await _deleteFromWishList();
        message = "Product deleted from your wish list";
      } else {
        await _addToWishList();
        message = "Product added to your wish list";
      }
      return message;
    } on Exception catch (e) {
      throw e;
    }
  }

  bool increaseQuantity() {
    if (_productQuantityAndPriceModel.quantity < product.numberInStock) {
      _updateModelWith(quantity: _productQuantityAndPriceModel.quantity + 1);
      return true;
    }
    return false;
  }

  bool decreaseQuantity() {
    if (_productQuantityAndPriceModel.quantity > 0) {
      _updateModelWith(quantity: _productQuantityAndPriceModel.quantity - 1);
      return true;
    }
    return false;
  }

  Future<void> rateTheProductByNStars(int n) async {
    try {
      await _services.rateProductWithNStars(n, uid, product.id);
    } on Exception catch (e) {
      throw e;
    }
    fetchProductCustomerRates();
    // _ratesModel[n-1]++;
    // _updateCostumerRatesModel(rates : _ratesModel);
  }

  void _updateModelWith({
    int quantity,
    bool isProductInWishList,
    bool isLoading,
  }) {
    _productQuantityAndPriceModel = _productQuantityAndPriceModel.copyWith(
      quantity: quantity,
      isProductInWishList: isProductInWishList,
      isLoading: isLoading,
    );
    _modelStreamController.sink.add(_productQuantityAndPriceModel);
  }

  void updateProduct(Product updatedProduct) {
    product = updatedProduct;
  }

  void _updateCostumerRatesModel({List<int> rates,}) {
    _ratesModel = rates;
    _ratesStreamController.sink.add(rates);
  }

  Future<List<int>> fetchProductCustomerRates() async {
    List<int> rates = [];
    for (int i = 5; i > 0; i--) {
      int n = await _services.readProductNumberOfRatesForNStars(i, product.id);
      rates.add(n);
    }
    _ratesModel = rates;
    _updateCostumerRatesModel(rates: rates);
    return rates;
  }

  List<int> _ratesModel = [];
}
