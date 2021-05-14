import 'package:auto_buy/widgets/loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductImage extends StatelessWidget {
  final String productName;
  final String productURL;

  const ProductImage({
    Key key,
    this.productName,
    this.productURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => inform(context),
      child: CachedNetworkImage(
        imageUrl: productURL,
        placeholder: (context, url) => LoadingImage(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 0.5 * MediaQuery.of(context).size.height,
      ),
    );
  }

  void inform(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              productName,
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
                  productURL,
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
