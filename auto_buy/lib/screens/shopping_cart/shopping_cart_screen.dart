import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: CloudFirestoreService.instance.collectionStream(path: path, builder: builder),
              builder: (context, snapshot) {
                GridView(
                  
                );
              },
            ),
          ],
        ),
      )
    );
  }
}
