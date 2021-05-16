import 'dart:async';

import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/product_rate.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';
import 'package:flutter/cupertino.dart';

import 'backend/product_info_screen_Services.dart';
import 'backend/product_quantity_and_price_model.dart';

class ProductInfoScreenBloc {
  ProductInfoScreenServices _services = ProductInfoScreenServices();
  Product product;
  final String uid;

  ProductInfoScreenBloc({@required this.product, @required this.uid});

  Stream<Product> get productOnChangeStream =>
      _services.getProductStream(product.id);

  void updateProduct(Product updatedProduct) {
    product = updatedProduct;
  }

  final StreamController<ProductQuantityAndPriceModel>
      _quantityAndPriceModelStreamController = StreamController.broadcast();

  ProductQuantityAndPriceModel _productQuantityAndPriceModel =
      ProductQuantityAndPriceModel();

  Stream<ProductQuantityAndPriceModel> get productQuantityAndPriceModelStream =>
      _quantityAndPriceModelStreamController.stream;

  int get quantity => _productQuantityAndPriceModel.quantity;

  void disposeQuantityAndPriceModelStream() =>
      _quantityAndPriceModelStreamController.close();

  String get increasingQuantityErrorMessage => product.numberInStock > 0
      ? "You cannot buy more than ${product.numberInStock} items"
      : "The product is out of stock for now";

  bool get isProductInWishList =>
      _productQuantityAndPriceModel.isProductInWishList;

  double get totalPrice =>
      _productQuantityAndPriceModel.quantity * product.price;

  Future<void> checkProductInUserWishList() async {
    bool exists = await _services.checkProductInWishList(uid, product.id);
    print(exists);
    _updateQuantityAndPriceModelWith(isProductInWishList: exists);
  }

  Future<void> _addToWishList() async {
    await _services.addProductToUserWishList(uid, product.id);
    _updateQuantityAndPriceModelWith(isProductInWishList: true);
  }

  Future<void> _deleteFromWishList() async {
    await _services.deleteProductToUserWishList(uid, product.id);
    _updateQuantityAndPriceModelWith(isProductInWishList: false);
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

        _updateQuantityAndPriceModelWith(quantity: 0);

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
      _updateQuantityAndPriceModelWith(
          quantity: _productQuantityAndPriceModel.quantity + 1);
      return true;
    }
    return false;
  }

  bool decreaseQuantity() {
    if (_productQuantityAndPriceModel.quantity > 0) {
      _updateQuantityAndPriceModelWith(
          quantity: _productQuantityAndPriceModel.quantity - 1);
      return true;
    }
    return false;
  }


  void _updateQuantityAndPriceModelWith({
    int quantity,
    bool isProductInWishList,
    bool isLoading,
  }) {
    _productQuantityAndPriceModel = _productQuantityAndPriceModel.copyWith(
      quantity: quantity,
      isProductInWishList: isProductInWishList,
      isLoading: isLoading,
    );
    _quantityAndPriceModelStreamController.sink
        .add(_productQuantityAndPriceModel);
  }

  ///***************************************************************************

  ///***************************************************************************

  final StreamController<List<int>> _ratesStreamController =
      StreamController.broadcast();

  Stream<List<int>> get ratesStream => _ratesStreamController.stream;

  void disposeRatesStream() => _ratesStreamController.close();

  void _updateCostumerRatesModel({
    List<int> rates,
  }) {
    _ratesStreamController.sink.add(rates);
  }

  Future<List<int>> fetchProductCustomerRates() async {
    print("Start fetching Rates");
    List<int> starsCount = [0, 0, 0, 0, 0, 0];
    List<Rate> rates = await _services.readProductRates(product.id);
    // List<int> starsCount = [0,0,0,0,0,0];
    print(rates.length);
    for (int i = 0; i < rates.length; i++) {
      print(rates[i].nStars);
      starsCount[rates[i].nStars]++;
    }

    _updateCostumerRatesModel(rates: starsCount);
    return starsCount;
  }

  ///*************************************************************************

  ///*************************************************************************
  UserRatingStarsModel ratingStarsModel = UserRatingStarsModel();
  StreamController<UserRatingStarsModel> _ratingStarsStreamController =
      StreamController<UserRatingStarsModel>.broadcast();

  void disposeRatingStarsStream() => _ratingStarsStreamController.close();

  Stream<UserRatingStarsModel> get ratingStarsModelStream =>
      _ratingStarsStreamController.stream;

  void starPressed(int i) {
    _updateRatingStarsModel(
      starPressed: true,
      starPressedIndex: i,
    );
  }

  Future<void> rateTheProductByNStars(int n) async {
    try {
      await _services.rateProductWithNStars(n, uid, product.id);
      fetchProductCustomerRates();
    } on Exception catch (e) {
      throw e;
    }
  }

  _updateRatingStarsModel({
    bool starPressed,
    int starPressedIndex,
  }) {
    ratingStarsModel = ratingStarsModel.copyWith(
        starPressed: starPressed, starPressedIndex: starPressedIndex);
    _ratingStarsStreamController.sink.add(ratingStarsModel);
  }

  ///*************************************************************************
}

class UserRatingStarsModel {
  final bool starPressed;
  final int starPressedIndex;

  UserRatingStarsModel({this.starPressed = false, this.starPressedIndex = 0});

  UserRatingStarsModel copyWith({
    bool starPressed,
    int starPressedIndex,
  }) {
    return UserRatingStarsModel(
      starPressed: starPressed ?? this.starPressed,
      starPressedIndex: starPressedIndex ?? this.starPressedIndex,
    );
  }
}
//**************