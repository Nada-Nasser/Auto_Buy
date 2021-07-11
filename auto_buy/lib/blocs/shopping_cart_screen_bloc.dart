import 'dart:async';

import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';

class ShoppingCartScreenBloc {

  bool reset = false;
  StreamController<bool> totalPriceController;
  Stream<bool> totalPriceStream;
  List<String> productIds;
  Map<String,int> productIdsAndQuantity;
  Map<String,double> productIdsAndPrices;

  ShoppingCartScreenBloc(){
    totalPriceController = StreamController.broadcast();
    totalPriceStream = totalPriceController.stream;
  }

  resetState(){
    reset = !reset;
    totalPriceController.sink.add(reset);
  }
  
  Future<double> calculateTotalPrice(String cartPath,String productPath) async{
    productIds = [];
    productIdsAndQuantity = {};
    productIdsAndPrices = {};
    double totalSum = 0.0;

    dynamic cartItems  = await CloudFirestoreService.instance.getCollectionData(collectionPath: cartPath, builder: (Map<String, dynamic> data, String documentId){
      Map<String, dynamic> output = {
        "data": data,
        "id": documentId
      };
      return output;
    });

    for(int i = 0 ; i < cartItems.length;i++)
    {
      dynamic productMap = await CloudFirestoreService.instance.readOnceDocumentData(collectionPath: productPath,
              documentId: cartItems[i]['id'],
              builder: (Map<String, dynamic> data, String documentId) => data);
      Product product = Product.fromMap(productMap, cartItems[i]['id']);
      totalSum += product.hasDiscount
          ? product.priceAfterDiscount * cartItems[i]['data']['quantity']
          : product.price * cartItems[i]['data']['quantity'];
      productIds.add(product.id);

      productIdsAndQuantity.update(
        product.id,
        (existingValue) => cartItems[i]['data']['quantity'],
        ifAbsent: () => cartItems[i]['data']['quantity'],
      );

      productIdsAndPrices.update(
        product.id,
        (existingValue) =>
            product.hasDiscount ? product.priceAfterDiscount : product.price,
        ifAbsent: () =>
            product.hasDiscount ? product.priceAfterDiscount : product.price,
      );
    }
    // print('in bloc');
    print(productIdsAndPrices);
    return totalSum;
  }

  void dispose(){
    totalPriceController.close();
  }
}