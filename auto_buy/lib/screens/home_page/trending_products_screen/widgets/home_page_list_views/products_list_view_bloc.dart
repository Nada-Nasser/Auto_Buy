import 'dart:async';

import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/list_type.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/products_services.dart';

class ProductsListViewBloc {
  final ProductsBackendServices _productsBackendServices =
      ProductsBackendServices();
  CloudFirestoreService _firestoreService = CloudFirestoreService.instance;

  String firestorePath;
  final ListType type;
  final String uid;

  ProductsListViewBloc({this.type, this.uid});

  Future<List<Product>> readProducts() async {
    if (type == ListType.MOST_TRENDING) {
      return _trendingProducts();
    } else
      return _recommendedProducts();
  }

  Future<List<Product>> _trendingProducts() async {
    try {
      List<Product> products =
          await _productsBackendServices.readProductsFromFirestore();
      products.sort((a, b) {
        return a.compareTo(b);
      });
      products = products.reversed.toList();
      int top10 = 1;

      List<Product> trending = [];
      for (int i = 0; i < products.length; i++) {
        trending.add(products[i]);
        top10++;
        if (top10 == 10) break;
      }
      return trending;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Product>> _recommendedProducts() async {
    try {
      List<Product> products = [];

      Map<String, dynamic> data = await _firestoreService.readOnceDocumentData(
          documentId: uid,
          collectionPath: "/users_orders",
          builder: (Map<String, dynamic> data, String documentId) => data);

      if (data == null) return [];

      List<dynamic> orderIDs = await _firestoreService.readOnceDocumentData(
          documentId: uid,
          collectionPath: "/users_orders",
          builder: (Map<String, dynamic> data, String documentId) =>
              data['orders_ids']);
      int top20 = 1;

      if (orderIDs == null) return [];

      for (int i = 0; i < orderIDs.length; i++) {
        List<dynamic> productsIds =
            await _firestoreService.readFieldValueFromDocument(
          collectionPath: "/orders/",
          documentID: "${orderIDs[i]}",
          fieldName: "product_ids",
        );

        for (int j = 0; j < productsIds.length; j++) {
          Product p =
              await _productsBackendServices.readProduct(productsIds[j]);
          products.add(p);
          top20++;
          if (top20 == 20) break;
        }
      }

      return products;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

/*
  Stream<List<ProductsList>> modelStream() {
    if (type == ListType.MOST_TRENDING) {
      firestorePath = APIPath.trendingProductsPath();
      return databaseServices.trendingProductsStream();
    } else if (type == ListType.EVENT_COLLECTION) {
      firestorePath = APIPath.eventProductsPath();
      return databaseServices.eventProductsStream();
    } else {
      firestorePath = APIPath.eventProductsPath();
      return databaseServices.eventProductsStream();
    }
  }*/
/*
  Future<List<Product>> fetchProducts(List<String> ids) async {
    List<Product> items = [];

    for (int i = 0; i < ids.length; i++) {
      final product = await databaseServices.readProduct(ids[i]);
      items.add(product);
    }
    _updateModelWith(items: items);
    return items;
  }
*/
/*
  final StreamController<List<Product>> _modelStreamController =
      StreamController.broadcast();

  List<Product> products = [];

  Stream<List<Product>> get productsStream => _modelStreamController.stream;

  void dispose() => _modelStreamController.close();

  void _updateModelWith({List<Product> items}) {
    products.clear();
    products.addAll(items);
    _modelStreamController.sink.add(products);
  }*/
}
