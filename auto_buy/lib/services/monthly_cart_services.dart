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

  Future<List<MonthlyCartItem>> readMonthlyCartProducts(
          String uid, String cartName) async =>
      _firestoreService.getCollectionData(
          collectionPath:
          APIPath.userMonthlyCartProductsCollectionPath(uid, cartName),
          builder: (values, id) => MonthlyCartItem.fromMap(values, id));

  Future<void> addProductToMonthlyCart(String uid, String cartName, MonthlyCartItem product) async =>
      _firestoreService.setDocument(
        documentPath: APIPath.userMonthlyCartProductDocumentPath(
          uid,
          cartName,
          product.productId,
        ),
        data: product.toMap(),
      );

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
        MonthlyCartModel(name: name, dateTime: selectedDate);

    await _firestoreService.setDocument(
        documentPath: APIPath.userMonthlyCartDocument(uid, name),
        data: monthlyCartModel.toMap());
  }
}
