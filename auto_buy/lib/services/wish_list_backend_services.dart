import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class WishListServices {
  final _firestoreService = CloudFirestoreService.instance;

  Future<void> addProductToUserWishList(String uid, String productID) async =>
      await _firestoreService.setDocument(
        documentPath: APIPath.userWishListProductPath(uid, productID),
        data: {},
      );

  Future<void> deleteProductToUserWishList(
          String uid, String productID) async =>
      await _firestoreService.deleteDocument(
        path: APIPath.userWishListProductPath(uid, productID),
      );

  Future<bool> checkProductInWishList(String uid, String productID) async =>
      await _firestoreService.checkExist(
        docPath: APIPath.userWishListProductPath(
          uid,
          productID,
        ),
      );
}
