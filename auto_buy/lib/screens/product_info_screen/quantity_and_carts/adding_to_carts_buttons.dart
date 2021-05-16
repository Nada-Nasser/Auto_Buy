import 'package:auto_buy/screens/product_info_screen/backend/product_quantity_and_price_model.dart';
import 'package:auto_buy/screens/product_info_screen/quantity_and_carts/wish_list_button.dart';
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
        stream: bloc.productQuantityAndPriceModelStream,
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
          WishListButton(),
          // _addingToWishListWidget(context),
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

  Future<void> onClickShoppingCartButton(BuildContext context) async {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    String msg = await bloc.onClickShoppingCartButton();
    showInSnackBar(msg, context);
  }
}
