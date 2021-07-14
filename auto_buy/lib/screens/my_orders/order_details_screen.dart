import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  List<dynamic> productIds;
  Map<String,dynamic> productIdsAndQuantity;
  double price;
  OrderDetailsScreen({@required this.productIds, this.productIdsAndQuantity,@required this.price});
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Order price : ${widget.price.toStringAsFixed(2)}\$"),
      ),
      body: Container(
          child: GridView.builder(
        itemCount: widget.productIds.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height),
        ),
        itemBuilder: (context, index) {
          ///this feature builder goes through each item in the user orders
          return FutureBuilder(
              future: CloudFirestoreService.instance.readOnceDocumentData(
                  collectionPath: "/products/",
                  documentId: "${widget.productIds[index]}",
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.productIdsAndQuantity!=null?"pcs ${widget.productIdsAndQuantity[widget.productIds[index]]}":"1",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        FutureBuilder(
                            future: FirebaseStorageService.instance
                                .downloadURL(snapshot.data['pic_path']),
                            builder: (context, image) {
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
