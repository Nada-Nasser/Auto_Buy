import 'package:flutter/foundation.dart';

class APIPath {
  static String advertisementImageRef(String adID) =>
      "/images/advertises/$adID";

  static String advertisementsPath() => "/advertisements";

  static String productPath({@required String productID}) =>
      "/products/$productID";

  static String productsPath() => "/products";

  static String trendingProductsPath() => "/trending_products";

  static String eventProductsPath() => "/event_products";

  static String userShoppingCartItemPath(String uid, String itemID) =>
      "/shopping_carts/$uid/shopping_cart_items/$itemID";

  static String userWishListProductPath(String uid, String productID) =>
      "/wish_lists/$uid/wish_list_products/$productID";

  static String userWishList(String uid) =>
      "/wish_lists/$uid/wish_list_products";
}
