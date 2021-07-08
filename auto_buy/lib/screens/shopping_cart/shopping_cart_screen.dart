import 'package:auto_buy/blocs/shopping_cart_screen_bloc.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/cart_checkout_screen/cart_checkout_screen.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  List<String> productIds = [];
  double totalPrice;
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  ShoppingCartScreenBloc _cartScreenBloc = ShoppingCartScreenBloc();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
        appBar: customAppBar(context),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5, top: 10,right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.orange,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "My Shopping Cart",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    StreamBuilder(
                      stream: _cartScreenBloc.totalPriceStream,
                      builder: (context, reset) {
                        return  FutureBuilder(
                            future: _cartScreenBloc.calculateTotalPrice("/shopping_carts/${auth.uid}/shopping_cart_items","/products/"),
                            builder:(context,price){
                              if(price.hasData){
                                widget.totalPrice = price.data;
                                print(widget.productIds);
                                return Text("total cost is ${price.data} \$",style: TextStyle(
                                  fontSize: 18,
                                ),);
                              }else{
                                return Text("Your cost is 0.00\$");
                              }
                            }
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                ///this stream builder gets an array of all products inside the user's cart
                child: StreamBuilder(
                    stream: CloudFirestoreService.instance.collectionStream(
                      path: "/shopping_carts/${auth.uid}/shopping_cart_items/",
                      builder: (Map<String, dynamic> data, String documentId) {
                        Map<String, dynamic> output = {
                          "data": data,
                          "id": documentId
                        };
                        return output;
                      },
                    ),
                    builder: (context, alldata) {
                      if (alldata.hasData) {
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
                            ///this feature builder goes through each item in the user cart
                            return FutureBuilder(
                                future: CloudFirestoreService.instance
                                    .readOnceDocumentData(
                                        collectionPath: "/products/",
                                        documentId:
                                            "${alldata.data[index]['data']['product_id']}",
                                        builder: (data, documentId) {
                                          Map<String, dynamic> output = {
                                            "data": data,
                                            "id": documentId
                                          };
                                          return output;
                                        }),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Product product =
                                    Product.fromMap(
                                        snapshot.data['data'],
                                        snapshot.data['id']);
                                    if(!widget.productIds.contains(product.id))
                                      {
                                        print("adding product");
                                        widget.productIds.add(product.id);
                                      }
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "pcs ${alldata.data[index]['data']['quantity']}",
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                          FutureBuilder(
                                              future: FirebaseStorageService
                                                  .instance
                                                  .downloadURL(
                                                      snapshot.data['data']
                                                          ['pic_path']),
                                              builder: (context, image) {
                                                if (image.hasData) {
                                                  return GestureDetector(
                                                    onLongPress: () async {
                                                      await onLongPressProduct(
                                                        context,
                                                        product,
                                                        "/shopping_carts/${auth.uid}/shopping_cart_items/",
                                                        "${alldata.data[index]['id']}",
                                                      _cartScreenBloc,
                                                      );
                                                    },
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          fullscreenDialog:
                                                              true,
                                                          builder: (context) =>
                                                              ProductInfoScreen
                                                                  .create(
                                                            context,
                                                            product,
                                                            image.data,
                                                          ),
                                                        ),
                                                      ).then((value) {setState(() {});});

                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: image.data,
                                                      placeholder:
                                                          (context, url) =>
                                                              LoadingImage(),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
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
                        return Container(
                          child: Center(
                            child: Text("Your shopping cart is empty"),
                          ),
                        );
                      }
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        padding: EdgeInsets.all(20)
                      ),
                      onPressed: () {
                          if(_cartScreenBloc.productIds.length == 0)
                              showInSnackBar("your cart is empty", context);
                            else{
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => CartCheckoutScreen(
                                  orderPrice: widget.totalPrice,
                                  productIDs: widget.productIds,
                                  isMonthlyCart: false,))).then((value) => _cartScreenBloc.resetState());
                          }
                      },
                      child: Text(
                        "Check Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

Future<void> onLongPressProduct(
  BuildContext context,
  Product product,
  String collectionPath,
  String documentId,
  ShoppingCartScreenBloc bloc,
) async {
  int quantityInCart = await CloudFirestoreService.instance
      .readOnceDocumentData(
          collectionPath: collectionPath,
          documentId: documentId,
          builder: (Map<String, dynamic> data, String documentId) =>
              data['quantity']);
  int newQuantity = quantityInCart;
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("${product.name}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You can delete this product from your shopping cart",
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    await CloudFirestoreService.instance
                        .deleteDocument(path: collectionPath + documentId);
                    bloc.resetState();
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Delete"),
                ),
                SizedBox(height: 5),
                Text(
                  "or",
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 5),
                Text(
                  "update the quantity you want from this product",
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => {
                        setState(() {
                          if (quantityInCart > 0)
                            quantityInCart--;
                          else {
                            showInSnackBar(
                                "Quantity can not be less than zero", context);
                          }
                        })
                      },
                      child: Text(
                        "-",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 0.10 * MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Text("$quantityInCart"),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => setState(() {
                        quantityInCart++;
                        // newQuantity++;
                      }),
                      child: Text(
                        "+",
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 0.09 * MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    int productNumberInStock =
                        await getProductNumber(product.id);
                    if (quantityInCart == 0) {
                      await CloudFirestoreService.instance
                          .deleteDocument(path: collectionPath + documentId);
                      bloc.resetState();
                      Navigator.of(context).pop(true);
                    } else if (quantityInCart<=productNumberInStock) {
                      ///update user's order quantity
                      await CloudFirestoreService.instance.updateDocumentField(
                          collectionPath: collectionPath,
                          documentID: documentId,
                          fieldName: 'quantity',
                          updatedValue: quantityInCart);
                      bloc.resetState();
                      Navigator.of(context).pop();
                    }
                    else if (quantityInCart > productNumberInStock) {
                      showInSnackBar("Quantity is more than in stock", context);
                      bloc.resetState();
                    }
                  },
                  child: Text("update"),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("cancel"),
              ),
            ],
          );
        });
      });
}

Future<int> getProductNumber(String productId) async {
  return await CloudFirestoreService.instance.readOnceDocumentData(
      collectionPath: "products/",
      documentId: "$productId",
      builder: (Map<String, dynamic> data, String documentId) =>
          data["number_in_stock"]);
}


