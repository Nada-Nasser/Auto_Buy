import 'package:auto_buy/models/monthly_cart_model.dart';
import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/order_model.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class CheckingOutServices {
  final _firestoreService = CloudFirestoreService.instance;
  final ProductsBackendServices _productsBackendServices =
      ProductsBackendServices();



  Future<void> addNewOrder({String uid, Map<String, dynamic> address, DateTime selectedDate, List<String> productIDs,
      double price}) async
  {
    orderModel oneOrderModel = orderModel(
        userID: uid,
        address: address,
        price: price,
        productIDs: productIDs,
        deliveryDate: selectedDate);

    String ID = await _firestoreService.addDocument(documentPath: APIPath.ordersDocuemtPath(), data: oneOrderModel.toMap());

    bool flag = false;
   flag = await _firestoreService.checkExist(
        // check if user exists in the orders_users
        docPath: APIPath.userOrdersDocumentPath(uid));

    if (flag) {
      await _firestoreService.updateDocumentField(
        collectionPath: APIPath.userOrdersPath(),
        documentID: uid,
        fieldName: "order_ids",
        updatedValue: FieldValue.arrayUnion([ID]),
      );
    } else {
      await _firestoreService.setDocument(documentPath: APIPath.userOrdersDocumentPath(uid), data: {'order_ids':[ID]});
    }
  }
}
