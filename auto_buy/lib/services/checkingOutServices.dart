import 'package:auto_buy/models/order_model.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';
import 'monthly_cart_services.dart';

class CheckingOutServices {
  final _firestoreService = CloudFirestoreService.instance;

  Future<void> addNewOrder(
      {String uid,
      Map<String, dynamic> address,
      DateTime selectedDate,
      List<String> productIDs,
      double price,
      Map<String, int> productIdAndQuantity,
      Map<String, double> productIdAndPrices,
      isMonthlyCart = false,
      cartName}) async {
    orderModel oneOrderModel = orderModel(
      userID: uid,
      address: address,
      price: price,
      productIDs: productIDs,
      deliveryDate: selectedDate,
      productIdsAndQuantity: productIdAndQuantity,
      orderDate: DateTime.now(),
      status: "pending",
      productIdsAndPrices: productIdAndPrices,
    );

    String ID = await _firestoreService.addDocument(
        documentPath: APIPath.ordersDocuemtPath(), data: oneOrderModel.toMap());

    if (isMonthlyCart)
      await MonthlyCartServices().createCheckedOutMonthlyCarts(
          oneOrderModel: oneOrderModel, uid: uid, cartName: cartName);

    bool flag = false;
    flag = await _firestoreService.checkExist(
        // check if user exists in the orders_users
        docPath: APIPath.userOrdersDocumentPath(uid));

    ///if user already has orders (exists in users_orders collection) then just update order_ids array
    ///else create the document with the user id and create the order_ids array
    if (flag) {
      await _firestoreService.updateDocumentField(
        collectionPath: APIPath.userOrdersPath(),
        documentID: uid,
        fieldName: "orders_ids",
        updatedValue: FieldValue.arrayUnion([ID]),
      );
    } else {
      await _firestoreService.setDocument(
          documentPath: APIPath.userOrdersDocumentPath(uid),
          data: {
            'orders_ids': [ID]
          });
    }
  }

  ///this function removes user's shopping cart items and updates the database
  Future removeItemsFromCart(
      {String shoppingCartPath,
      bool isShoppingCart = true,
      Map<String, int> productIdsAndQuantity}) async {
    ///reduce the quantity in stock
    productIdsAndQuantity.forEach((productID, quantity) async {
      int productNumberInStock = await getProductNumberInStock(productID);
      int numberInCart = quantity;
      int newProductQuantity = productNumberInStock - numberInCart;
      if (newProductQuantity < 0) newProductQuantity = 0;
      await _firestoreService.updateDocumentField(
          collectionPath: "/products/",
          documentID: productID,
          fieldName: "number_in_stock",
          updatedValue: newProductQuantity);

      ///empty te user's cart
      if (isShoppingCart)
        await _firestoreService.deleteDocument(
            path: shoppingCartPath + "/${productID}");
    });
  }

  Future<int> getProductNumberInStock(String productId) async {
    return await CloudFirestoreService.instance.readOnceDocumentData(
        collectionPath: "products/",
        documentId: "$productId",
        builder: (Map<String, dynamic> data, String documentId) =>
            data["number_in_stock"]);
  }
}
