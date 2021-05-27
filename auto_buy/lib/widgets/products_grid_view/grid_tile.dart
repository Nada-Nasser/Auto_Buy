import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final int quantity;
  final double height;
  final double width;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductGridTile(
      {Key key,
      @required this.product,
      this.quantity,
      this.height = 200,
      this.width = 200,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: _buildContent());
  }

  Widget _buildContent() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      onTap: onTap ??
          () {
            print("PRODUCT_MODEL_ON_TAP");
          },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            if (quantity != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(height: height * 0.1, child: Text("$quantity Pcs"))
                ],
              ),
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
            fontSize: 15,
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
      height: 0.7 * height,
    );
  }
}
