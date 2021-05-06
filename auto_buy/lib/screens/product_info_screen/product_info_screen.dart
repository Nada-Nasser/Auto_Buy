import 'dart:ui';

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

  double get price => quantity * widget.product.price;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProductInWishList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      //   appBar:customAppBar(context),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(""),
        elevation: 10,
      ),
      body: _buildContent(context),
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Widget _buildContent(BuildContext context) {
    List<Widget> content = [
      _buildProductNameAndPriceWidget(context),
      _buildProductImageWidget(context),
      _buildQuantityAndTotalPriceWidget(context),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                isProductInWishList = !isProductInWishList;
                showInSnackBar("Product added to your wish list");
              });
            },
            icon: Icon(
              isProductInWishList ? Icons.favorite : Icons.favorite_border,
              color: isProductInWishList ? Colors.red : Colors.black,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            label: Text(
              "Add to Shopping Cart",
            ),
          ),
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (BuildContext context, int index) {
          return content[index];
        },
      ),
    );
  }

  Widget _buildQuantityAndTotalPriceWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityWidget(context),
        _buildTotalPriceWidget(context),
      ],
    );
  }

  Widget _buildTotalPriceWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        "EGP ${price.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 0.06 * MediaQuery.of(context).size.width,
        ),
        softWrap: true,
      ),
    );
  }

  Widget _buildQuantityWidget(BuildContext context) {
    return Container(
      width: 0.40 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ), //Border.all
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(
              2.0,
              2.0,
            ), //Offset
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ), //BoxDecoration

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                if (quantity > 0)
                  quantity--;
                else
                  showInSnackBar("You cannot buy less than 0 item");
              });
            },
            child: Container(
              //  color: Colors.grey,
              child: Text(
                "-",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 0.12 * MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "$quantity",
            style: TextStyle(
              fontSize: 0.08 * MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                if (quantity < widget.product.numberInStock)
                  quantity++;
                else
                  showInSnackBar(
                      "You cannot buy more than ${widget.product.numberInStock} items");
              });
            },
            child: Text(
              "+",
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 0.12 * MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImageWidget(BuildContext context) {
    return Image.asset(
      widget.product.picturePath,
      height: 0.5 * MediaQuery.of(context).size.height,
    );
  }

  Widget _buildProductNameAndPriceWidget(BuildContext context) {
    return Row(
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
    );
  }
}
