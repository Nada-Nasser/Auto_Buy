import 'package:auto_buy/models/order_model.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class CheckingOutServices {
  final _firestoreService = CloudFirestoreService.instance;
  final ProductsBackendServices _productsBackendServices =
      ProductsBackendServices();



  Future<void> addNewOrder({String uid, Map<String, dynamic> address, DateTime selectedDate, List<String> productIDs,
      double price, Map<String,int> productIdAndQuantity,Map<String,double> productIdAndPrices}) async
  {
    orderModel oneOrderModel = orderModel(
      userID: uid,
      address: address,
      price: price,
      productIDs: productIDs,
      deliveryDate: selectedDate,
      productIdsAndQuantity: productIdAndQuantity,
      orderDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      status: "pending",
      productIdsAndPrices: productIdAndPrices,
    );

    String ID = await _firestoreService.addDocument(documentPath: APIPath.ordersDocuemtPath(), data: oneOrderModel.toMap());

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
      await _firestoreService.setDocument(documentPath: APIPath.userOrdersDocumentPath(uid), data: {'orders_ids':[ID]});
    }
  }

  ///this function removes user's shopping cart items and updates the database
  Future removeItemsFromCart({String cartPath,String deletePath}) async
  {
    ///get user's cart items
    dynamic cartItems  = await _firestoreService.getCollectionData(collectionPath: cartPath, builder: (Map<String, dynamic> data, String documentId){
      // Map<String, dynamic> output = {
      //   "data": data,
      //   "id": documentId
      // };
      return data;
    });
    ///reduce the quantity in stock
    for(int i = 0 ; i < cartItems.length; i++)
    {
      int productNumberInStock =
      await getProductNumber(cartItems[i]['product_id']);
      int numberInCart = cartItems[i]["quantity"];
      int newProductQuantity = productNumberInStock - numberInCart;
      if(newProductQuantity < 0)
        newProductQuantity = 0;
      await _firestoreService.updateDocumentField(collectionPath: "/products/", documentID: cartItems[i]['product_id'], fieldName: "number_in_stock", updatedValue: newProductQuantity);
      ///empty te user's cart
      await _firestoreService.deleteDocument(path: cartPath+"/${cartItems[i]["product_id"]}");
    }

  }

  Future<int> getProductNumber(String productId) async {
    return await CloudFirestoreService.instance.readOnceDocumentData(
        collectionPath: "products/",
        documentId: "$productId",
        builder: (Map<String, dynamic> data, String documentId) =>
        data["number_in_stock"]);
  }

}
