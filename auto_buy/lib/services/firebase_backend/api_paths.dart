import 'package:flutter/foundation.dart';

class APIPath {
  static String advertisementImageRef(String adID) =>
      "/images/advertises/$adID";

  static String productImageRef(String productID) =>
      "images/products/$productID";

  static String advertisementsPath() => "/advertisements";

  static String productPath({@required String productID}) =>
      "/products/$productID";

  static String productsPath() => "/products";

  static String Categories() => "/categories";

  static String trendingProductsPath() => "/trending_products";

  static String eventProductsPath() => "/event_products";

  static String userShoppingCartItemPath(String uid, String itemID) =>
      "/shopping_carts/$uid/shopping_cart_items/$itemID";

  static String userShoppingCartProductsCollectionPath(
    String uid,
  ) =>
      "/shopping_carts/$uid/shopping_cart_items";

  static String userWishListProductPath(String uid, String productID) =>
      "/wish_lists/$uid/wish_list_products/$productID";

  static String userWishList(String uid) =>
      "/wish_lists/$uid/wish_list_products";

  static String productRatesCollectionPath(String productId) =>
      "/products/$productId/rates";

  static String userRateOnProductDocumentPath(String productId, String uid) =>
      "/products/$productId/rates/$uid";

  static String userMonthlyCartsPath(String uid) =>
      "/monthly_carts/$uid/monthly_carts";

  static String userMonthlyCartProductsCollectionPath(
          String uid, String cartName) =>
      "/monthly_carts/$uid/monthly_carts/$cartName/cart_products";

  static String userMonthlyCartProductDocumentPath(
          String uid, String cartName, String productId) =>
      "/monthly_carts/$uid/monthly_carts/$cartName/cart_products/$productId";

  static String userMonthlyCartDocument(String uid, String cartName) =>
      "/monthly_carts/$uid/monthly_carts/$cartName";
}
