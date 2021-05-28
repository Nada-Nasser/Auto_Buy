import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  ///testing data
  // List<Map<String, dynamic>> testData = [
  //   {
  //     "address": {
  //       "building_number": 3,
  //       "city": "cairo",
  //       "street": "ahmed oraby"
  //     },
  //     "delivery_date": "4/2/2020",
  //     "price": "325.32",
  //     "product_ids": [1, 2, 3, 4],
  //     "user_id": "VDdL7063FDQC3EYpkxIBFIEJuNf2 "
  //   },
  //   {
  //     "address": {"building_number": 4, "city": "cairo", "street": "haram"},
  //     "delivery_date": "4/2/2020",
  //     "price": "325.32",
  //     "product_ids": [1, 2, 3, 4],
  //     "user_id": "VDdL7063FDQC3EYpkxIBFIEJuNf2 "
  //   },
  // ];
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
                    return Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        itemCount: orderIds.length,
                        itemBuilder: (context, index) {
                          ///this future builder gets orders from their ids
                          return FutureBuilder(
                              future: CloudFirestoreService.instance
                                  .readOnceDocumentData(
                                      collectionPath: "/orders/",
                                      documentId: "${orderIds[index]}",
                                      builder: (Map<String, dynamic> data, String documentId) => data),
                              builder: (context, snapshotOrderDetail) {
                                if (snapshotOrderDetail.hasData) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.list_alt,
                                            size: 50,
                                            color: Colors.purple,
                                          ),
                                          padding: EdgeInsets.only(right: 3),
                                        ),
                                        // SizedBox(width: 30,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Delivery Date",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              softWrap: true,
                                            ),
                                            Text(
                                              snapshotOrderDetail
                                                  .data['delivery_date'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: IconButton(
                                            icon: Icon(LineAwesomeIcons.envelope_open, color: Colors.green),
                                            onPressed: (){
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) => OrderDetailsScreen(snapshotOrderDetail.data['product_ids']),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.remove_circle, color: Colors.red,),
                                          onPressed: () {
                                            var toBeRemoved = orderIds.indexOf(orderIds[index]);
                                            print(orderIds);
                                            showOrderdeleteDialog(context,auth.uid,orderIds,toBeRemoved);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              });
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
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
void showOrderdeleteDialog(BuildContext context,String docId, var updatedValue,int toBeRemoved) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(5),
        title: new Text("Do you want to delete this order?"),
        actions: <Widget>[
          new TextButton(
            child: new Text("Yes", style: TextStyle(color: Colors.red, fontSize: 20),),
            onPressed: () async{
              updatedValue.removeAt(toBeRemoved);
              await CloudFirestoreService.instance.updateDocumentField(collectionPath: "users_orders", documentID: docId, fieldName: "orders_ids", updatedValue: updatedValue);
              Navigator.of(context).pop();
            },
          ),
          new TextButton(
            child: new Text("No", style: TextStyle(color: Colors.green, fontSize: 20),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}