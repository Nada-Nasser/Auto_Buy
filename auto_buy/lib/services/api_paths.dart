import 'package:flutter/foundation.dart';

class APIPath {
  static String advertisementImageRef(String adID) =>
      "/images/advertises/$adID";

  static String advertisementsPath() => "/advertisements";

  static String productPath({@required String productID}) =>
      "/products/$productID";

  static String productsPath() => "/products";
}
