import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/peoducts_list.dart';
import 'package:auto_buy/services/api_paths.dart';
import 'package:auto_buy/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


final _firestoreService = CloudFirestoreService.instance;

Future queryProductDataByName(String query) async {
  return FirebaseFirestore.instance
      .collection('products')
      .where('name', isGreaterThanOrEqualTo: query)
      .snapshots();
}
Stream<List<ProductsList>> eventProductsStream() =>
    _firestoreService.collectionStream(
      path: APIPath.productsPath(),
      builder: (data, documentId) => ProductsList.fromMap(data, documentId),
      queryBuilder: (query) => query.where('name', isGreaterThanOrEqualTo: 'Elmatbakh Egyptian Rice')
    );
class GetUserName extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body : Text(s));
  }
}
