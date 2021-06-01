import 'package:auto_buy/models/monthly_cart_model.dart';
import 'package:auto_buy/models/monthly_cart_product_item.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class MonthlyCartServices {
  final _firestoreService = CloudFirestoreService.instance;

  Stream<List<String>> userMonthlyCartsNamesStream(String uid) =>
      _firestoreService.collectionStream(
        path: APIPath.userMonthlyCartsPath(uid),
        builder: (data, documentId) => _documentIdBuilder(data, documentId),
      );

  Future<List<String>> readUserMonthlyCartsNames(String uid) async =>
      _firestoreService.getCollectionData(
        collectionPath: APIPath.userMonthlyCartsPath(uid),
        builder: (data, documentId) => _documentIdBuilder(data, documentId),
      );

  Future<List<MonthlyCartModel>> readAllMonthlyCarts(String uid) async {
    return _firestoreService.getCollectionData(
        collectionPath: APIPath.userMonthlyCartsPath(uid),
        builder: (data, documentId) =>
            MonthlyCartModel.fromMap(data, documentId));
  }

  Future<List<MonthlyCartItem>> readMonthlyCartProducts(
          String uid, String cartName) async =>
      _firestoreService.getCollectionData(
          collectionPath:
              APIPath.userMonthlyCartProductsCollectionPath(uid, cartName),
          builder: (values, id) => MonthlyCartItem.fromMap(values, id));

  Future<void> addProductToMonthlyCart(
      String uid, String cartName, MonthlyCartItem product) async {
    /// steps:
    /// 1- check if product exists to (set / update) document.

    try {
      /// check if product exists
      /// if true:
      ///          fetch the product to get the old quantity
      ///          set Doc with sum of quantities
      /// if false:
      ///          set the doc.
      final flag = await _firestoreService.checkExist(
          docPath: APIPath.userMonthlyCartProductDocumentPath(
              uid, cartName, product.productId));
      if (flag) {
        final oldCartItem = await _firestoreService.readOnceDocumentData(
          collectionPath:
              APIPath.userMonthlyCartProductsCollectionPath(uid, cartName),
          documentId: product.productId,
          builder: (values, id) => MonthlyCartItem.fromMap(values, id),
        );
        int quantity = oldCartItem.quantity + product.quantity;
        final cart = MonthlyCartItem(
          quantity: quantity,
          productId: product.productId,
        );

        _firestoreService.setDocument(
          documentPath: APIPath.userMonthlyCartProductDocumentPath(
            uid,
            cartName,
            product.productId,
          ),
          data: cart.toMap(),
        );
      } else {
        _firestoreService.setDocument(
          documentPath: APIPath.userMonthlyCartProductDocumentPath(
            uid,
            cartName,
            product.productId,
          ),
          data: product.toMap(),
        );
      }
    } on Exception catch (e) {
      rethrow;
    }
  }

  String _documentIdBuilder(Map<String, dynamic> data, String documentId) {
    return documentId;
  }

  Future<bool> checkIfMonthlyCartExist(String uid, String name) async =>
      await _firestoreService.checkExist(
        docPath: APIPath.userMonthlyCartDocument(uid, name),
      );

  Future<void> addNewMonthlyCart(
      String uid, String name, DateTime selectedDate) async {
    MonthlyCartModel monthlyCartModel =
        MonthlyCartModel(name: name, deliveryDate: selectedDate);

    await _firestoreService.setDocument(
        documentPath: APIPath.userMonthlyCartDocument(uid, name),
        data: monthlyCartModel.toMap());
  }

  Future<void> deleteProductFromMonthlyCart(
      String uid, String selectedCartName, String productId) async {
    await _firestoreService.deleteDocument(
        path: APIPath.userMonthlyCartProductDocumentPath(
            uid, selectedCartName, productId));
  }

  Future<void> updateProductQuantityInMonthlyCart(
      String uid, String cartName, String productId, int quantity) async {
    await _firestoreService.updateDocumentField(
      collectionPath:
          APIPath.userMonthlyCartProductsCollectionPath(uid, cartName),
      documentID: productId,
      fieldName: "quantity",
      updatedValue: quantity,
    );
  }

  Future<void> deleteMonthlyCart(String uid, String selectedCartName) async {
    await _firestoreService.deleteDocument(
        path: APIPath.userMonthlyCartDocument(uid, selectedCartName));
  }

  Future<void> updateDeliveryDateInMonthlyCart(
      String uid, String cartName, DateTime selectedDate) async {
    await _firestoreService.updateDocumentField(
      collectionPath: APIPath.userMonthlyCartsPath(uid),
      documentID: cartName,
      fieldName: "delivery_date",
      updatedValue: selectedDate,
    );
  }
}
