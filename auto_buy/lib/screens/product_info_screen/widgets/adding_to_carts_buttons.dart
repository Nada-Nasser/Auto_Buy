import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class AddingToCartsButtons extends StatefulWidget {
  // final Product product;
  final String productID;

  const AddingToCartsButtons({
    Key key,
    this.productID,
  }) : super(key: key);

  @override
  _AddingToCartsButtonsState createState() => _AddingToCartsButtonsState();
}

class _AddingToCartsButtonsState extends State<AddingToCartsButtons> {
  bool isProductInWishList = false;

  @override
  Widget build(BuildContext context) {
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
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: OutlinedButton.icon(
        onPressed: () {
          showInSnackBar("Product added to your shopping cart", context);
        },
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
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
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
}
