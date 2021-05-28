import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final double height;
  final double width;
  final VoidCallback onTap;

  const ProductTile({
    Key key,
    @required this.product,
    this.height = 200,
    this.width = 200,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ??
          () {
            _onTapProduct(context,product);
          },
      child: Container(
        padding: EdgeInsets.all(2),
        //margin: EdgeInsets.all(2),
        width: width,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          children: [
            _productImage(),
            _buildProductTitle(),
          ],
        ),
      ),
    );
  }

  Container _buildProductTitle() {
    return Container(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: width,
        height: height * 0.1,
        child: Text(
          product.name,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _productImage() {
    return CachedNetworkImage(
      imageUrl: this.product.picturePath,
      placeholder: (context, url) => LoadingImage(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: 0.5 * height,
    );
  }

  _onTapProduct(BuildContext context, Product product) {
    //  Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductInfoScreen.create(
          context,
          product,
          product.picturePath,
        ),
      ),
    );
  }
}
