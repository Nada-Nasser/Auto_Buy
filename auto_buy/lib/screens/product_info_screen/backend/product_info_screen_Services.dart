import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/product_rate.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';
import 'package:auto_buy/services/monthly_cart_services.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:auto_buy/services/shopping_cart_services.dart';
import 'package:auto_buy/services/wish_list_backend_services.dart';

class ProductInfoScreenServices {
  final _shoppingCartServices = ShoppingCartServices();
  final _wishListServices = WishListServices();
  final _monthlyCartServices = MonthlyCartServices();
  final _productServices = ProductsBackendServices();

  Stream<Product> getProductStream(String productID) =>
      _productServices.getProductStream(productID);

  Future<List<Rate>> readProductRates(String productId) async =>
      await _productServices.readProductRates(productId);

  Future<void> rateProductWithNStars(
          int n, String uid, String productID) async =>
      await _productServices.rateProductWithNStars(n, uid, productID);

  Future<void> addProductToUserWishList(String uid, String productID) async =>
      await _wishListServices.addProductToUserWishList(uid, productID);

  Future<void> deleteProductToUserWishList(
          String uid, String productID) async =>
      await _wishListServices.deleteProductToUserWishList(uid, productID);

  Future<bool> checkProductInWishList(String uid, String productID) async =>
      await _wishListServices.checkProductInWishList(uid, productID);

  Future<void> addProductToUserShoppingCart(
          String uid, ShoppingCartItem cartItem, int numberInStock) async =>
      await _shoppingCartServices.addProductToUserShoppingCart(
          uid, cartItem, numberInStock);

  Future<List<String>> readUserMonthlyCartsNames(String uid) async =>
      await _monthlyCartServices.readUserMonthlyCartsNames(uid);

  Future<List<MonthlyCartItem>> readMonthlyCartProducts(
          String uid, String cartName) async =>
      await _monthlyCartServices.readMonthlyCartItems(uid, cartName);

  Future<void> addProductToMonthlyCart(
          String uid, String cartName, MonthlyCartItem product) async =>
      await _monthlyCartServices.addProductToMonthlyCart(
          uid, cartName, product);

  Future<List<Product>> readCategoryProducts(String categoryID) async =>
      await _productServices.readCategoryProducts(categoryID);
}
