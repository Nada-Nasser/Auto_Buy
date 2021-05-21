import 'package:auto_buy/models/peoducts_list.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/widgets/home_page_products_list.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*Future queryProductDataByName(String query) async {
  return FirebaseFirestore.instance
      .collection('products')
      .where('name', isGreaterThanOrEqualTo: query)
      .snapshots();
}*/

class GetUserName extends StatefulWidget {
  @override
  _GetUserNameState createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  final _firestoreService = CloudFirestoreService.instance;
  final _storageService = FirebaseStorageService.instance;

  Future<List<Product>> readCategoryProducts() async {
    List<Product> products = await _firestoreService.getCollectionData(
      collectionPath: '/products',
      builder: (value, id) => Product.fromMap(value, id),
      queryBuilder: (query) =>
          query.where('name', isGreaterThanOrEqualTo: 'Rice'),
    );

    for (int i = 0; i < products.length; i++) {
      String url = await _storageService.downloadURL(products[i].picturePath);
      products[i].picturePath = url;
    }

    return products;
  }

  List<Product> productsList = [];


  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
        future: readCategoryProducts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(
              children: [
                Container(width: 50, child: LoadingImage()),
              ],
            );
          } else
            return ProductsListView(height: MediaQuery.of(context).size.height
              ,productsList: snapshot.data,isHorizontal: false,);
        },
      );
  }
}
/*  Stream<List<Product>> eventProductsStream() =>
      _firestoreService.collectionStream(
        path: APIPath.productsPath(),
        builder: (data, documentId) => Product.fromMap(data, documentId),
        // queryBuilder: (query) => query.where('name', isEqualTo: 'Elmatbakh Egyptian Rice')
      );*/