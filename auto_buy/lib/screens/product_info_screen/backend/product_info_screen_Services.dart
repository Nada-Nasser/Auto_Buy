import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';
import 'package:auto_buy/services/api_paths.dart';
import 'package:auto_buy/services/firestore_service.dart';

class ProductInfoScreenServices {
  final _firestoreService = CloudFirestoreService.instance;

  Stream<Product> getProductStream(String productID) =>
      _firestoreService.documentStream(
        path: APIPath.productPath(productID: productID),
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );

  Future<void> addProductToUserWishList(String uid, String productID) async =>
      await _firestoreService.setDocument(
        path: APIPath.userWishListProductPath(uid, productID),
        data: {},
      );

  Future<void> deleteProductToUserWishList(
          String uid, String productID) async =>
      await _firestoreService.deleteDocument(
        path: APIPath.userWishListProductPath(uid, productID),
      );

  Future<void> addProductToUserShopping(
      String uid, ShoppingCartItem cartItem, int numberInStock) async {
    try {
      /// add product to shopping cart
      await _firestoreService.setDocument(
        path: APIPath.userShoppingCartItemPath(
            uid, DateTime.now().toIso8601String()),
        data: cartItem.toMap(),
      );

      /// decrease product.numberInStock
      print('$numberInStock - ${cartItem.quantity}');
      await _firestoreService.updateDocumentField(
        collectionPath: APIPath.productsPath(),
        documentID: cartItem.productID,
        fieldName: Product.numberInStockFieldName,
        updatedValue: numberInStock - cartItem.quantity,
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<bool> checkProductInWishList(String uid, String productID) async =>
      await _firestoreService.checkExist(
        docPath: APIPath.userWishListProductPath(
          uid,
          productID,
        ),
      );
}
