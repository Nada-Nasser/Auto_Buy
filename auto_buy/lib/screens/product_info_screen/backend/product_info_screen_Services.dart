import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/product_rate.dart';
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
        documentPath: APIPath.userWishListProductPath(uid, productID),
        data: {},
      );

  Future<void> deleteProductToUserWishList(String uid, String productID) async =>
      await _firestoreService.deleteDocument(
        path: APIPath.userWishListProductPath(uid, productID),
      );

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

  Future<bool> checkProductInWishList(String uid, String productID) async =>
      await _firestoreService.checkExist(
        docPath: APIPath.userWishListProductPath(
          uid,
          productID,
        ),
      );

  Future<List<Rate>> readProductRates(String productId) async {
    List<Rate> rates = await _firestoreService.getCollectionData(
        collectionPath: APIPath.productRatesCollectionPath(productId),
        builder: (data, documentId) => Rate.fromMap(data, documentId));

    return rates;
  }

  Future<void> rateProductWithNStars(int n, String uid, String productID) async {
    try {
      Rate rate = Rate(nStars: n, id: uid);
      await _firestoreService.setDocument(
        documentPath: APIPath.userRateOnProductDocumentPath(productID, uid),
        data: rate.toMap(),
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<String>> readUserMonthlyCartsNames(String uid) async =>
      _firestoreService.getCollectionData(
        collectionPath: APIPath.userMonthlyCartsPath(uid),
        builder: (data, documentId) => documentIdBuilder(data, documentId),
      );

  Future<List<MonthlyCartItem>> readMonthlyCartProducts(
          String uid, String cartName) async =>
      _firestoreService.getCollectionData(
          collectionPath:
              APIPath.userMonthlyCartProductsCollectionPath(uid, cartName),
          builder: (values, id) => MonthlyCartItem.fromMap(values, id));

  Future<void> addProductToMonthlyCart(
          String uid, String cartName, MonthlyCartItem product) async =>
      _firestoreService.setDocument(
        documentPath: APIPath.userMonthlyCartProductDocumentPath(
          uid,
          cartName,
          product.productId,
        ),
        data: product.toMap(),
      );
}

String documentIdBuilder(Map<String, dynamic> data, String documentId) {
  return documentId;
}
