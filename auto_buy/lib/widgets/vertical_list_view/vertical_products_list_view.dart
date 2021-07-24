import 'package:auto_buy/main.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VerticalProductsListView extends StatelessWidget {
  final List<Product> productsList;
  final List<int> quantities;
  final Function(BuildContext context, Product product) onTap;
  final Function(BuildContext context, Product product) onLongPress;

  final bool isPriceHidden;
  final double listHeight;
  final double listWidth;
  final bool smallPic;

  const VerticalProductsListView({
    Key key,
    @required this.productsList,
    this.quantities,
    this.isPriceHidden = false,
    this.onTap,
    this.onLongPress,
    this.listHeight,
    this.listWidth,
    this.smallPic = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> content = _buildContent(context);
    if (productsList.isEmpty)
      return Container(
        padding: smallPic
            ? const EdgeInsets.all(0)
            : const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Center(
          child: Text(
            "There are no products found",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    return Container(
      padding: smallPic
          ? const EdgeInsets.all(0)
          : const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (BuildContext context, int index) {
          return content[index];
        },
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    List<Widget> w = [];

    for (int i = 0; i < productsList.length; i++) {
      ProductTile tile = ProductTile(
        smallPic: smallPic,
        product: productsList[i],
        onTap: () => onTap(context, productsList[i]),
        onLongPress: () => onLongPress(context, productsList[i]),
        quantity: quantities != null ? quantities[i] : null,
        isPriceHidden: isPriceHidden,
        height: listHeight,
        width: listWidth,
      );
      w.add(tile);
    }

    return w;
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  final int quantity;
  final bool isPriceHidden;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final double height;
  final double width;
  final bool smallPic;

  const ProductTile(
      {Key key,
      @required this.product,
      this.quantity,
      this.isPriceHidden = false,
      this.onTap,
      this.onLongPress,
      this.height,
      this.smallPic,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mywidth = width ?? MediaQuery.of(context).size.width;
    double myheight = height ?? null;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: mywidth,
        height: myheight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _productImage(),
            if (!smallPic)
              SizedBox(
                width: 10,
              ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProductName(),
                  if (!isPriceHidden) _productPrice(),
                  if (product.hasDiscount && !isPriceHidden)
                    _buildProductPriceBeforeDiscount(),
                  if (quantity != null) _productQuantity()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildProductPriceBeforeDiscount() {
    String price = "${product.price.toStringAsFixed(2)}";
    double percent = product.discountPercentage;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                Text(
                  "EGP $price",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              children: [
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
        ],
      ),
    );
  }

  Widget _productImage() {
    return CachedNetworkImage(
      imageUrl: this.product.picturePath,
      height: smallPic ? 50 : 100,
      width: MediaQuery.of(navigatorKey.currentContext).size.width/5,
      placeholder: (context, url) => SizedBox(
        child: CircularProgressIndicator(),
        height: 10,
        width: 10,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.fitHeight,
    );
  }

  Widget _buildProductName() {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Flexible(
          child: Text(
            product.name,
            overflow: TextOverflow.clip,
            maxLines: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _productPrice() {
    double price =
        product.hasDiscount ? product.priceAfterDiscount : product.price;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        "EGP ${price.toStringAsFixed(2)}",
        textAlign: TextAlign.start,
        //    softWrap: true,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  _productQuantity() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        "$quantity pcs",
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
