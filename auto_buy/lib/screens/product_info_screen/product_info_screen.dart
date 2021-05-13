import 'dart:ui';

import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/custom_search_bar.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
            margin: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
            child: customSearchBar(context)),
        title: Text(""),
        elevation: 10,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    List<Widget> content = [
      _buildProductNameAndPriceWidget(context),
      _buildProductImageWidget(context),
      _buildQuantityAndTotalPriceWidget(context),
      _addingToCartsWidgets(context),
      _buildProductDescriptionWidget(context),
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

  Container _buildProductDescriptionWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 30, 5, 20),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      decoration: _boxDecoration(Colors.black),
      child: Column(
        children: [
          _descriptionTitleWidget(context),
          SizedBox(height: 10),
          _descriptionContentWidget(context),
          SizedBox(height: 10),
          _buildDescriptionElementWidget(
              context, "Brand : ", widget.product.brand),
          SizedBox(height: 10),
          _buildDescriptionElementWidget(
              context, "Category : ", widget.product.categoryID),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  SizedBox _descriptionContentWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        widget.product.description,
        textAlign: TextAlign.start,
        softWrap: true,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 0.0446 * MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  SizedBox _descriptionTitleWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        "Product Description",
        style: TextStyle(
            color: Colors.grey[800],
            fontSize: 0.055 * MediaQuery.of(context).size.width,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
    );
  }

  Container _buildDescriptionElementWidget(
      BuildContext context, String title, String content) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 0.0456 * MediaQuery.of(context).size.width,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 0.0446 * MediaQuery.of(context).size.width,
            ),
          )
        ],
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
          color: Colors.deepOrangeAccent,
        ),
        label: Text(
          "Add to Shopping Cart",
          softWrap: true,
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 0.0446 * MediaQuery.of(context).size.width,
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
            if (isProductInWishList)
              showInSnackBar("Product added to your wish list", context);
            else
              showInSnackBar("Product deleted from your wish list", context);
          });
        },
        icon: Icon(
          isProductInWishList ? Icons.favorite : Icons.favorite_border,
          color: isProductInWishList ? Colors.red : Colors.red,
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
      width: 0.50 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //decoration: _boxDecoration(Colors.black),
      child: Column(
        children: [
          Text(
            "Total Price : ",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 0.0446 * MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              "EGP ${price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 0.06 * MediaQuery.of(context).size.width,
              ),
              softWrap: true,
            ),
          ),
        ],
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
                  showInSnackBar("You cannot buy less than 0 item", context);
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
                      "You cannot buy more than ${widget.product.numberInStock} items",
                      context);
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: inform,
      child: CachedNetworkImage(
        imageUrl: widget.product.picturePath,
        placeholder: (context, url) => LoadingImage(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 0.5 * MediaQuery.of(context).size.height,
      ),
      /*child: Image.asset(
        widget.product.picturePath,
        height: 0.5 * MediaQuery.of(context).size.height,
      ),*/
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
        color: Colors.black,
        width: 1.55,
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          offset: const Offset(
            0.0,
            0.0,
          ), //Offset
          blurRadius: 2.0,
          spreadRadius: 0.5,
        ),
        BoxShadow(
          color: Colors.white,
          offset: const Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ), //BoxShadow
      ],
    );
  }

  void inform() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              widget.product.name,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              //height: 0.4 * MediaQuery.of(context).size.height,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                initialScale: PhotoViewComputedScale.contained,
                imageProvider: NetworkImage(
                  widget.product.picturePath,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
