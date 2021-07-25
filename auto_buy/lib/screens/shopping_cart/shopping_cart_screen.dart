import 'package:auto_buy/blocs/shopping_cart_screen_bloc.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/cart_checkout_screen/cart_checkout_screen.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ShoppingCartScreen extends StatefulWidget {
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
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 5, top: 10, right: 5),
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
                        return FutureBuilder(
                            future: _cartScreenBloc.calculateTotalPrice(
                                "/shopping_carts/${auth.uid}/shopping_cart_items",
                                "/products/",
                                "/shopping_carts/${auth.uid}"
                            ),
                            builder: (context, price) {
                              if (price.hasData) {
                                widget.totalPrice = price.data;
                                return Text(
                                  ///Text("Total Price = EGP${widget.bloc.totalPrice.toStringAsFixed(3)}")
                                  "Total Price = EGP ${widget.totalPrice.toStringAsFixed(2)}",
                                );
                              } else{
                                return Text("Total Price = EGP 0.00");
                              }
                            });
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
                    builder: (context, alldata){
                      if (alldata.hasData) {
                        return ListView.builder(
                          itemCount: alldata.data.length,
                          itemBuilder: (context, index) {
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
                                print('what is going on');
                                print(alldata.data[index]['data']);
                                if (snapshot.hasData) {
                                  Product product = Product.fromMap(
                                      snapshot.data['data'],
                                      snapshot.data['id']);
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
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.all(8),
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
                                      child: Row(
                                        children: [
                                          FutureBuilder(
                                              future: FirebaseStorageService
                                                  .instance
                                                  .downloadURL(
                                                      snapshot.data['data']
                                                          ['pic_path']),
                                              builder: (context, image) {
                                                if (image.hasData) {
                                                  return GestureDetector(
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
                                                      )
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: image.data,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child: SizedBox(
                                                          child:
                                                              CircularProgressIndicator(),
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                      height: 100,
                                                      width: MediaQuery.of(
                                                                  navigatorKey
                                                                      .currentContext)
                                                              .size
                                                              .width /
                                                          5,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: SizedBox(
                                                      child:
                                                          CircularProgressIndicator(),
                                                      height: 10,
                                                      width: 10,
                                                    ),
                                                  );
                                                }
                                              }),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ///product name
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    child: Flexible(
                                                      child: Text(
                                                        product.name,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                ///product price
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 5, 0),
                                                  child: Text(
                                                    "EGP ${product.hasDiscount ? product.priceAfterDiscount.toStringAsFixed(2) : product.price.toStringAsFixed(2)}",
                                                    textAlign: TextAlign.start,
                                                    //    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),

                                                ///product discount
                                                if (product.hasDiscount)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "EGP ${product.price}",
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "-${product.discountPercentage.toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ///product quantity
                                                if (alldata.data[index]['data']
                                                        ['quantity'] !=
                                                    null)
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      "${alldata.data[index]['data']['quantity']} pcs",
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(),
                                      height: 10,
                                      width: 10,
                                    ),
                                  );
                                }
                              },
                            );
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
                        padding: EdgeInsets.all(20),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () async {
                        print('shopping cart length');
                        if (_cartScreenBloc.productIds.length == 0)
                          showInSnackBar("your cart is empty", context);
                        else {
                          await _cartScreenBloc.calculateTotalPrice(
                              "/shopping_carts/${auth.uid}/shopping_cart_items",
                              "/products/",
                              "/shopping_carts/${auth.uid}"
                          );
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => CartCheckoutScreen(
                                        orderPrice: widget.totalPrice,
                                        productIDs: _cartScreenBloc.productIds,
                                        productIdsAndQuantity: _cartScreenBloc
                                            .productIdsAndQuantity,
                                        productIdsAndPrices:
                                            _cartScreenBloc.productIdsAndPrices,
                                        isMonthlyCart: false,
                                      )));

                        }
                      },
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                    } else if (quantityInCart <= productNumberInStock) {
                      ///update user's order quantity
                      await CloudFirestoreService.instance.updateDocumentField(
                          collectionPath: collectionPath,
                          documentID: documentId,
                          fieldName: 'quantity',
                          updatedValue: quantityInCart);
                      bloc.resetState();
                      Navigator.of(context).pop();
                    } else if (quantityInCart > productNumberInStock) {
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
