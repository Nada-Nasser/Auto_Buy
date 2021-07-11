import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
        appBar: customAppBar(context),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "My WishList",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                ///this stream builder gets an array of integers to all wishlist item by the user
                child: StreamBuilder(
                    stream: CloudFirestoreService.instance.collectionStream(
                      path: "/wish_lists/${auth.uid}/wish_list_products",
                      builder: (Map<String, dynamic> data, String documentId) {
                        return documentId;
                      },
                    ),
                    //an array of integers
                    builder: (context, alldata) {
                      if (alldata.hasData) {
                        print(alldata.data);
                        // return Container();
                        return GridView.builder(
                          itemCount: alldata.data.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                            MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 2),
                          ),
                          itemBuilder: (context, index) {
                            ///this feature builder goes through each item in the user wishlist
                            return FutureBuilder(
                                future: CloudFirestoreService.instance
                                    .readOnceDocumentData(
                                    collectionPath: "/products/",
                                    documentId:
                                    "${alldata.data[index]}",
                                    builder: (data, documentId) {
                                      Map<String,dynamic> output={"data":data,"id":documentId};
                                      return output;
                                    }),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 40,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FutureBuilder(
                                              future: FirebaseStorageService
                                                  .instance
                                                  .downloadURL(snapshot
                                                  .data['data']['pic_path']),
                                              builder: (context, image) {
                                                Product product = Product.fromMap(snapshot.data['data'], snapshot.data['id']);
                                                if (image.hasData) {
                                                  return GestureDetector(
                                                    onTap: (){
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          fullscreenDialog: true,
                                                          builder: (context) => ProductInfoScreen.create(
                                                            context,
                                                            product,
                                                            image.data,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: image.data,
                                                      placeholder:
                                                          (context, url) =>
                                                          LoadingImage(),
                                                      errorWidget:
                                                          (context, url, error) =>
                                                          Icon(Icons.error),
                                                      width: double.infinity,
                                                      height: 0.5 * 200,
                                                    ),
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              }),
                                          Text(
                                            snapshot.data['data']['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.5),
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
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
