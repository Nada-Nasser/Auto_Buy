import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/api_paths.dart';
import 'package:auto_buy/services/firestore_service.dart';

class ProductInfoScreenServices {
  final _firestoreService = CloudFirestoreService.instance;

  Stream<Product> getProductStream(String productID) =>
      _firestoreService.documentStream(
        path: APIPath.productPath(productID: productID),
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );

  Future<void> addProductToUserWishList(String uid, String productID) async {}

  Future<void> deleteProductToUserWishList(
      String uid, String productID) async {}

  Future<void> addProductToUserShopping(String uid, String productID) async {}
}
