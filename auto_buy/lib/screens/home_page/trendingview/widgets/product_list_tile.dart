import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    Key key,
    @required this.imagePath,
    @required this.title,
    @required this.price,
    this.hasDiscount = true,
    this.priceBeforeDiscount = 100,
    this.onTap,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final double price;
  final bool hasDiscount;
  final double priceBeforeDiscount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final height = 250.0;
    final width = 200.0;
    return GestureDetector(
      onTap: onTap ?? () {},
      child: _buildContent(height, width),
    );
  }

  Container _buildContent(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          _productImage(width, height),
          SizedBox(height: 5),
          _buildProductTitle(width),
          _buildProductPrice(width),
          if (hasDiscount) _buildProductPriceBeforeDiscount(width),
        ],
      ),
    );
  }

  Padding _buildProductPriceBeforeDiscount(double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: SizedBox(
        width: width,
        child: Text(
          "\$${priceBeforeDiscount.toStringAsFixed(2)}",
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }

  Padding _buildProductPrice(double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: SizedBox(
        width: width,
        child: Text(
          "\$${price.toStringAsFixed(2)}",
          textAlign: TextAlign.start,
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
          title,
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

  Image _productImage(double width, double height) {
    return Image.asset(
      imagePath,
      width: width,
      height: 0.6 * height,
    );
  }
}
