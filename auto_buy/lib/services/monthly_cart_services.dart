import 'package:auto_buy/models/monthly_cart_model.dart';
import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/products_services.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class MonthlyCartServices {
  final _firestoreService = CloudFirestoreService.instance;
  final ProductsBackendServices _productsBackendServices =
      ProductsBackendServices();

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
    String uid,
    String cartName,
    MonthlyCartItem product,
  ) async {
    try {
      /// check if product exists
      /// if true:
      ///          fetch the product from monthly cart to get the old quantity
      ///          product quantity in the cart = sum of quantities
      ///          fetch the product to get its maximum demand for each user
      ///          check if the new quantity <= the maximum demand for each user for this product
      ///          if true
      ///             set Doc with sum of quantities
      ///          else:
      ///             Do nothing.
      /// if false:
      ///          set the doc.
      final flag = await _firestoreService.checkExist(
          // check if product exists in the cart
          docPath: APIPath.userMonthlyCartProductDocumentPath(
              uid, cartName, product.productId));
      if (flag) {
        // if true
        // fetch the product from monthly cart to get the old quantity
        final oldCartItem = await _firestoreService.readOnceDocumentData(
          collectionPath:
              APIPath.userMonthlyCartProductsCollectionPath(uid, cartName),
          documentId: product.productId,
          builder: (values, id) => MonthlyCartItem.fromMap(values, id),
        );
        //product quantity in the cart = sum of quantities
        int quantity = oldCartItem.quantity + product.quantity;

        // fetch the product to get its maximum demand for each user
        Product needProduct = await _firestoreService.readOnceDocumentData(
          collectionPath: APIPath.productsPath(),
          documentId: product.productId,
          builder: (value, id) => Product.fromMap(value, id),
        );

        final cart = MonthlyCartItem(
          quantity: quantity,
          productId: product.productId,
        );

        // check if the new quantity <= the maximum demand for each user for this product
        if (needProduct.maxDemandPerUser < quantity) {
          // if false
          throw Exception(
              "Couldn't add the product because you exceeded the demand limit");
        } else {
          // if true
          _firestoreService.setDocument(
            documentPath: APIPath.userMonthlyCartProductDocumentPath(
              uid,
              cartName,
              product.productId,
            ),
            data: cart.toMap(),
          );
        }
      } else {
        //if product does not exist in the cart
        _firestoreService.setDocument(
          documentPath: APIPath.userMonthlyCartProductDocumentPath(
            uid,
            cartName,
            product.productId,
          ),
          data: product.toMap(),
        );
      }
    } on Exception {
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
        MonthlyCartModel(name: name, deliveryDate: selectedDate ,isCheckedOut: false);

    await _firestoreService.setDocument(
        documentPath: APIPath.userMonthlyCartDocument(uid, name),
        data: monthlyCartModel.toMap());
  }

  Future<void> deleteProductFromMonthlyCart(
      String uid, String selectedCartName, String productId) async {
    await _firestoreService.deleteDocument(
        path: APIPath.userMonthlyCartProductDocumentPath(uid, selectedCartName, productId));
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
    await _firestoreService.deleteCollection(
        path: APIPath.userMonthlyCartProductsCollectionPath(uid, selectedCartName));
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

  Future<double> getMonthlyCartTotalPrice(String uid, String cartName) async {
    List<MonthlyCartItem> monthlyCartItems =
        await readMonthlyCartProducts(uid, cartName);
    double totalPrice = 0.0;
    for (int i = 0; i < monthlyCartItems.length; i++) {
      final item = monthlyCartItems[i];
      double price =
          await _productsBackendServices.getProductPrice(item.productId);
      totalPrice += price * item.quantity;
    }
    return totalPrice;
  }

  Future<void> setCheckedOut(
      String uid, String cartName) async {
    await _firestoreService.updateDocumentField(
      collectionPath: APIPath.userMonthlyCartsPath(uid),
      documentID: cartName,
      fieldName: "is_checkedout",
      updatedValue: true,
    );
  }

  Future<bool> getIsCheckedOut(String uid,String cartName) async{
    return await  _firestoreService.readOnceDocumentData(collectionPath: APIPath.userMonthlyCartsPath(uid) ,
        documentId:cartName, builder: (Map<String, dynamic> data, String documentId) =>
        data["is_checkedout"]);
  }
}
