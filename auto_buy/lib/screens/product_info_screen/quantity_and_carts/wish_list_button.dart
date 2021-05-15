import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product_info_screen_bloc.dart';

class WishListButton extends StatefulWidget {
  @override
  _WishListButtonState createState() => _WishListButtonState();
}

class _WishListButtonState extends State<WishListButton> {
  @override
  void initState() {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    bloc.checkProductInUserWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return Container(
      height: 0.15 * MediaQuery.of(context).size.width,
      width: 0.15 * MediaQuery.of(context).size.width,
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: IconButton(
        iconSize: 0.1 * MediaQuery.of(context).size.width,
        onPressed: () => onClickWishListButton(context),
        icon: Icon(
          bloc.isProductInWishList ? Icons.favorite : Icons.favorite_border,
          color: bloc.isProductInWishList ? Colors.red : Colors.red,
        ),
      ),
    );
  }

  Future<void> onClickWishListButton(BuildContext context) async {
    try {
      final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
      String message = await bloc.onClickWishListButton();
      showInSnackBar(message, context);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
