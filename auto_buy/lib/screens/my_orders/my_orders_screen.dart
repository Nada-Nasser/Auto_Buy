import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
                    Icons.list_alt,
                    color: Colors.purpleAccent,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "My Orders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              ///this future builder gets the ids of his orders
              child: StreamBuilder(
                stream: CloudFirestoreService.instance.documentStream(
                    path: "/users_orders/${auth.uid}",
                    builder: (Map<String, dynamic> data, String documentId) =>
                        data),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> orderIds = snapshot.data['orders_ids'];
                    List<dynamic> reverse = orderIds.reversed.toList();
                    return Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        itemCount: reverse.length,
                        itemBuilder: (context, index) {
                          ///this future builder gets orders from their ids
                          return FutureBuilder(
                              future: CloudFirestoreService.instance
                                  .readOnceDocumentData(
                                      collectionPath: "/orders/",
                                      documentId: "${reverse[index]}",
                                      builder: (Map<String, dynamic> data,
                                              String documentId) =>
                                          data),
                              builder: (context, snapshotOrderDetail) {
                                if (snapshotOrderDetail.hasData) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) =>
                                                OrderDetailsScreen(
                                                  productIds:
                                                      snapshotOrderDetail
                                                          .data['product_ids'],
                                                  productIdsAndQuantity:
                                                      snapshotOrderDetail.data[
                                                          'productid_quantity'],
                                                  price: snapshotOrderDetail
                                                      .data['price']
                                                      .toDouble(),
                                                  productIdsAndPrices:  snapshotOrderDetail.data['productid_prices'],
                                                )),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
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
                                      margin: EdgeInsets.all(10),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Delivery Date : ${DateFormat('yyyy-MM-dd').format(snapshotOrderDetail.data['delivery_date'].toDate()).toString()}',overflow:
                                              TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Text("Order price : EGP ${snapshotOrderDetail.data['price'].toStringAsFixed(2)}"),
                                          SizedBox(height: 3,),
                                          Row(
                                            children: [
                                              Text('Order Status :'),
                                              snapshotOrderDetail.data['status']=='pending'?Text(" ${snapshotOrderDetail.data['status']}",style: TextStyle(color: Colors.red),)
                                              :Text(" ${snapshotOrderDetail.data['status']}",style: TextStyle(color: Colors.green),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              });
                        },
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text("You don't have any orders"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///delete the all data[index]
void showOrderdeleteDialog(
    BuildContext context, String docId, var updatedValue, int toBeRemoved) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(5),
        title: new Text("Do you want to delete this order?"),
        actions: <Widget>[
          new TextButton(
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            onPressed: () async {
              updatedValue.removeAt(toBeRemoved);
              await CloudFirestoreService.instance.updateDocumentField(
                  collectionPath: "users_orders",
                  documentID: docId,
                  fieldName: "orders_ids",
                  updatedValue: updatedValue);
              Navigator.of(context).pop();
            },
          ),
          new TextButton(
            child: new Text(
              "No",
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
