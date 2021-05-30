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
        this.width = double.infinity,
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
        //height: 500,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            _buildProductPrice(width),
            if (product.hasDiscount) _buildProductPriceBeforeDiscount(width),
          ],
        ),
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

  Container _buildProductTitle() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        product.name,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _productImage() {
    return CachedNetworkImage(
      imageUrl: this.product.picturePath,
      placeholder: (context, url) => LoadingImage(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.fitHeight,
    );
  }
}