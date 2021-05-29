import 'package:auto_buy/models/shopping_cart_item.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class ShoppingCartServices {
  final _firestoreService = CloudFirestoreService.instance;

  Future<void> addProductToUserShoppingCart(
      String uid, ShoppingCartItem cartItem, int numberInStock) async {
    try {
      /// check if the product exists in user shopping cart
      final flag = await _firestoreService.checkExist(
          docPath: APIPath.userShoppingCartItemPath(uid, cartItem.productID));
      if (flag) {
        final oldCartItem = await _firestoreService.readOnceDocumentData(
          collectionPath: APIPath.userShoppingCartProductsCollectionPath(uid),
          documentId: cartItem.productID,
          builder: (values, id) => ShoppingCartItem.fromMap(values, id),
        );
        int quantity = oldCartItem.quantity + cartItem.quantity;
        final cart = ShoppingCartItem(
          quantity: quantity,
          lastModifiedDat: DateTime.now(),
          totalPrice: cartItem.totalPrice + oldCartItem.totalPrice,
          productID: cartItem.productID,
        );
        await _firestoreService.setDocument(
          documentPath: APIPath.userShoppingCartItemPath(uid, cart.productID),
          data: cart.toMap(),
        );
      } else {
        /// if not
        /// add product to shopping cart
        await _firestoreService.setDocument(
          documentPath:
              APIPath.userShoppingCartItemPath(uid, cartItem.productID),
          data: cartItem.toMap(),
        );
      }
    } on Exception catch (e) {
      throw e;
    }
  }
}
