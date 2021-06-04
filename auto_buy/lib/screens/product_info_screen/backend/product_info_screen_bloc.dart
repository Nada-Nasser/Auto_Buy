import 'dart:async';

import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/product_rate.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'product_info_screen_Services.dart';
import 'product_quantity_and_price_model.dart';
import 'user_rates_model.dart';

class ProductInfoScreenBloc {
  ProductInfoScreenServices _services = ProductInfoScreenServices();
  WishListButtonServices _wishListBloc = WishListButtonServices();

  Product product;
  final String uid;
  List<Product> sameCategoryProducts = [];

  ProductInfoScreenBloc({@required this.product, @required this.uid});

  Stream<Product> get productOnChangeStream =>
      _services.getProductStream(product.id);

  Future<void> getProductSameCategory() async {
    sameCategoryProducts =
        await _services.readCategoryProducts(product.categoryID);
  }


  Future<void> checkProductInUserWishList() async =>
      await _wishListBloc.checkProductInUserWishList(uid, product.id);

  Future<String> onClickWishListButton() async =>
      await _wishListBloc.onClickWishListButton(uid, product.id);

  Stream<bool> get productInWishListStream =>
      _wishListBloc.productInWishListStream;

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

  String get increasingQuantityErrorMessage =>
      product.numberInStock > 0
      ? "You cannot buy more than $quantity items from this product"
      : "The product is out of stock for now";

  double get totalPrice => product.hasDiscount
      ? _productQuantityAndPriceModel.quantity * product.priceAfterDiscount
      : _productQuantityAndPriceModel.quantity * product.price;

  Future<String> onClickShoppingCartButton() async {
    if (product.numberInStock == 0) return "The product is out of stock";
    try {
      if (quantity > 0) {
        final cartItem = ShoppingCartItem(
          productID: product.id,
          totalPrice: totalPrice,
          quantity: quantity,
          lastModifiedDat: DateTime.now(),
        );

        await _services.addProductToUserShoppingCart(
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

  bool increaseQuantity() {
    if (_productQuantityAndPriceModel.quantity < product.numberInStock &&
        _productQuantityAndPriceModel.quantity < product.maxDemandPerUser) {
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
    bool isLoading,
  }) {
    _productQuantityAndPriceModel = _productQuantityAndPriceModel.copyWith(
      quantity: quantity,
      isLoading: isLoading,
    );
    _quantityAndPriceModelStreamController.sink
        .add(_productQuantityAndPriceModel);
  }

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

  Future<List<String>> getMonthlyCartsNames() async =>
      await _services.readUserMonthlyCartsNames(uid);

  Future<String> onClickMonthlyCartButton(String monthlyCartName) async {
    try {
      MonthlyCartItem item = MonthlyCartItem(
        productId: product.id,
        quantity: quantity,
      );

      if (quantity < 1) return "You can't add 0 items to your monthly carts";

      await _services.addProductToMonthlyCart(uid, monthlyCartName, item);

      return "Product added to $monthlyCartName monthly cart";
    } on FirebaseException catch (e) {
      print(e.message);
      return "${e.message}";
    } on Exception {
      return "Couldn't add this quantity in the cart";
    }
  }

  ///*************************************************************************
}

class WishListButtonServices {
  ProductInfoScreenServices _services = ProductInfoScreenServices();
  bool _isProductInWishList = false;
  StreamController<bool> _productInWishListStreamController =
      StreamController.broadcast();

  void disposeProductInWishListStreamController() =>
      _productInWishListStreamController.close();

  Stream<bool> get productInWishListStream =>
      _productInWishListStreamController.stream;

  void updateProductInWishListStream(bool productInWishList) {
    _isProductInWishList = productInWishList;
    _productInWishListStreamController.sink.add(productInWishList);
  }

  Future<void> checkProductInUserWishList(String uid, String productID) async {
    bool exists = await _services.checkProductInWishList(uid, productID);
    print(exists);
    updateProductInWishListStream(exists);
  }

  Future<void> _addToWishList(String uid, String productID) async {
    await _services.addProductToUserWishList(uid, productID);
    updateProductInWishListStream(true);
  }

  Future<void> _deleteFromWishList(String uid, String productID) async {
    await _services.deleteProductToUserWishList(uid, productID);
    updateProductInWishListStream(false);
  }

  Future<String> onClickWishListButton(String uid, String productID) async {
    try {
      String message = "Something Went Wrong";
      if (_isProductInWishList) {
        await _deleteFromWishList(uid, productID);
        message = "Product deleted from your wish list";
      } else {
        await _addToWishList(uid, productID);
        message = "Product added to your wish list";
      }
      return message;
    } on Exception catch (e) {
      throw e;
    }
  }
}
