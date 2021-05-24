import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/services/product_map_to_product.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  var _productIds;
  OrderDetailsScreen(dynamic _productIds) {
    this._productIds = _productIds;
  }
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: GridView.builder(
        itemCount: widget._productIds.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemBuilder: (context, index) {
          ///this feature builder goes through each item in the user wishlist
          return FutureBuilder(
              future: CloudFirestoreService.instance.readOnceDocumentData(
                  collectionPath: "/products/",
                  documentId: "${widget._productIds[index]}",
                  builder: (data, documentId) => data),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data);
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    height: 200,
                    width: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder(
                            future: FirebaseStorageService.instance
                                .downloadURL(snapshot.data['pic_path']),
                            builder: (context, image) {
                              Product product =
                                  createProductFromSnapShot(snapshot.data);
                              if (image.hasData) {
                                return CachedNetworkImage(
                                  imageUrl: image.data,
                                  placeholder: (context, url) => LoadingImage(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  width: double.infinity,
                                  height: 0.5 * 200,
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                        Text(
                          snapshot.data['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              });
        },
      )),
    );
  }
}
