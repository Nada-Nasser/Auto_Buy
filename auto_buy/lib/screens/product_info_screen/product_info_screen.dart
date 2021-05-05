import 'package:auto_buy/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductInfoScreen extends StatefulWidget {
  final Product product;

  const ProductInfoScreen({Key key, this.product}) : super(key: key);

  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar:customAppBar(context),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(""),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 0.6 * MediaQuery.of(context).size.width,
                  child: Text(
                    widget.product.name,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  child: Text(
                    'EGP ${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset(
              widget.product.picturePath,
              height: 0.5 * MediaQuery.of(context).size.height,
            ),
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Container(
                      //  color: Colors.grey,
                      child: Text("-"),
                    ),
                  ),
                  Text(
                    "$quantity",
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Text("+"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
