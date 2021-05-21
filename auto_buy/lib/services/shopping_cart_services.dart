import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class ShoppingCartServices {
  final _firestoreService = CloudFirestoreService.instance;

  Future<void> addProductToUserShoppingCart(
      String uid, ShoppingCartItem cartItem, int numberInStock) async {
    try {
      /// add product to shopping cart
      await _firestoreService.setDocument(
        documentPath: APIPath.userShoppingCartItemPath(
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
}
