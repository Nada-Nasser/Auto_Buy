import 'package:auto_buy/screens/product_info_screen/backend/product_quantity_and_price_model.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product_info_screen_bloc.dart';

class AddingToCartsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return StreamBuilder<ProductQuantityAndPriceModel>(
        stream: bloc.modelStream,
        builder: (context, snapshot) {
          return _buildContent(context);
        });
  }

  Container _buildContent(BuildContext context) {
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
        onPressed: () => onClickShoppingCartButton(context),
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
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return FutureBuilder(
        future: bloc.checkProductInUserWishList(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Container(
            height: 0.15 * MediaQuery.of(context).size.width,
            width: 0.15 * MediaQuery.of(context).size.width,
            decoration: boxDecorationWithBordersAndShadow(Colors.black),
            child: IconButton(
              iconSize: 0.1 * MediaQuery.of(context).size.width,
              onPressed: () => onClickWishListButton(context),
              icon: Icon(
                bloc.isProductInWishList
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: bloc.isProductInWishList ? Colors.red : Colors.red,
              ),
            ),
          );
        });
  }

  Future<void> onClickShoppingCartButton(BuildContext context) async {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    bloc.onClickShoppingCartButton();
    showInSnackBar("Product added to your shopping cart", context);
  }

  Future<void> onClickWishListButton(BuildContext context) async {
    try {
      final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
      String message = await bloc.onClickWishListButton();
      showInSnackBar(message, context);
    } on Exception catch (e) {
      // TODO
      rethrow;
    }
  }
}
