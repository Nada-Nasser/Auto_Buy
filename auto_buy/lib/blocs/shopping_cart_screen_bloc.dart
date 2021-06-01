import 'dart:async';

import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';

class ShoppingCartScreenBloc {

  bool reset = false;
  StreamController<bool> totalPriceController;
  Stream<bool> totalPriceStream;

  ShoppingCartScreenBloc(){
    totalPriceController = StreamController.broadcast();
    totalPriceStream = totalPriceController.stream;
  }

  resetState(){
    reset = !reset;
    totalPriceController.sink.add(reset);
  }
  
  Future<double> calculateTotalPrice(String cartPath,String productPath) async{
    dynamic cartItems  = await CloudFirestoreService.instance.getCollectionData(collectionPath: cartPath, builder: (Map<String, dynamic> data, String documentId){
      Map<String, dynamic> output = {
        "data": data,
        "id": documentId
      };
      return output;
    });
    double totalSum = 0.0;

    for(int i = 0 ; i < cartItems.length;i++)
    {
      dynamic productMap = await CloudFirestoreService.instance.readOnceDocumentData(collectionPath: productPath,
          documentId: cartItems[i]['id'], builder: (Map<String, dynamic> data, String documentId)=>data);
      Product product =
      Product.fromMap(productMap, cartItems[i]['id']);
      totalSum += product.hasDiscount?product.priceAfterDiscount*cartItems[i]['data']['quantity']
          :product.price*cartItems[i]['data']['quantity'];
    }
    return totalSum;
  }

  void dispose(){
    totalPriceController.close();
  }
}