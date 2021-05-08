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
  bool isProductInWishList = false;

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
      _addingToCartsWidgets(context),
      Container(
        margin: EdgeInsets.fromLTRB(5, 30, 5, 20),
        width: MediaQuery.of(context).size.width,
        decoration: _boxDecoration(Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Product Description",
                  style: TextStyle(
                    fontSize: 0.05 * MediaQuery.of(context).size.width,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  widget.product.description,
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
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

  Widget _addingToCartsWidgets(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 30, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _addingToWishListWidget(context),
          _addingToShoppingCartWidget(context),
        ],
      ),
    );
  }

  Widget _addingToShoppingCartWidget(BuildContext context) {
    return Container(
      height: 0.15 * MediaQuery.of(context).size.width,
      decoration: _boxDecoration(Colors.black),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(
          Icons.shopping_cart_outlined,
          size: 0.1 * MediaQuery.of(context).size.width,
        ),
        label: Text(
          "Add to Shopping Cart",
          softWrap: true,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 0.045 * MediaQuery.of(context).size.width,
            //fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _addingToWishListWidget(BuildContext context) {
    return Container(
      height: 0.15 * MediaQuery.of(context).size.width,
      width: 0.15 * MediaQuery.of(context).size.width,
      decoration: _boxDecoration(Colors.black),
      child: IconButton(
        iconSize: 0.1 * MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            isProductInWishList = !isProductInWishList;
            showInSnackBar("Product added to your wish list");
          });
        },
        icon: Icon(
          isProductInWishList ? Icons.favorite : Icons.favorite_border,
          color: isProductInWishList ? Colors.red : Colors.orange,
        ),
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
      decoration: _boxDecoration(Colors.black),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 0.06 * MediaQuery.of(context).size.width,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          child: Text(
            'EGP ${widget.product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 0.06 * MediaQuery.of(context).size.width,
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration _boxDecoration(Color color) {
    return BoxDecoration(
      border: Border.all(
        color: color,
        width: 1.55,
      ), //Border.all
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        /*BoxShadow(
          color: color,
          offset: const Offset(
            2.0,
            2.0,
          ), //Offset
          blurRadius: 3.0,
          spreadRadius: 1.0,
        ), */
        BoxShadow(
          color: Colors.white,
          offset: const Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ), //BoxShadow
      ],
    );
  }
}
