import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    Key key,
    this.onTap,
    this.backgroundColor = Colors.white,
    @required this.product,
    this.width = 200,
    this.height = 300,
  }) : super(key: key);

  final Product product;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // final height = 300.0;
    //   final width = 200.0;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ??
          () {
            print("PRODUCT_MODEL_ON_TAP");
          },
      child: _buildContent(height, width),
    );
  }

  Container _buildContent(double height, double width) {
    return Container(
      height: height,
      width: width,
      color: backgroundColor,
      child: Column(
        children: [
          _productImage(width, height),
          SizedBox(height: 5),
          _buildProductTitle(width),
          _buildProductPrice(width),
          if (product.hasDiscount) _buildProductPriceBeforeDiscount(width),
        ],
      ),
    );
  }

  Padding _buildProductPriceBeforeDiscount(double width) {
    String price = "${product.price.toStringAsFixed(2)}";

    double percent = product.discountPercentage;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Text(
              "EGP $price",
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "-${percent.toStringAsFixed(2)}%",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildProductPrice(double width) {
    double price =
        product.hasDiscount ? product.priceAfterDiscount : product.price;

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: SizedBox(
        width: width,
        child: Text(
          "EGP ${price.toStringAsFixed(2)}",
          textAlign: TextAlign.start,
      //    softWrap: true,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Container _buildProductTitle(double width) {
    return Container(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: width,
        child: Text(
          product.name,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _productImage(double width, double height) {
    return CachedNetworkImage(
      imageUrl: this.product.picturePath,
      placeholder: (context, url) => LoadingImage(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: 0.5 * height,
    );
  }
}
