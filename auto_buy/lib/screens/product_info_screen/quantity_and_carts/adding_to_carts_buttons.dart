import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/selection_dialog.dart';
import '../backend/product_info_screen_bloc.dart';

class AddingToCartsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Container _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 30, 4, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _addToCartButton(
              context,
              "Add To Shopping Cart",
              Icons.shopping_cart_outlined,
              (context) => onClickShoppingCartButton(context)),
          SizedBox(
            height: 20,
          ),
          _addToCartButton(context, "Add To Monthly Cart", Icons.calendar_today,
              (context) => onClickMonthlyCartButton(context)),
        ],
      ),
    );
  }

  Widget _addToCartButton(
    BuildContext context,
    String text,
    IconData icon,
    Future<void> Function(BuildContext context) onTap,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          size: 0.1 * MediaQuery.of(context).size.width,
          color: Colors.deepOrangeAccent,
        ),
        label: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 0.054 * MediaQuery.of(context).size.width,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () => onTap(context),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.white,
          textStyle: TextStyle(
            color: Colors.grey[800],
            fontSize: 0.055 * MediaQuery.of(context).size.width,
            fontWeight: FontWeight.bold,
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

  onClickMonthlyCartButton(BuildContext context) async {
    //TODO : Select Monthly Cart name from Dialog?
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    List<String> names = await bloc.getMonthlyCartsNames();
    print(names);
    selectionDialog(
      context,
      _addTheProductToMonthlyCart,
      names,
      "Monthly Cart Names",
      "Please select monthly cart name you want to add the product in.",
    );
  }

  Future<void> _addTheProductToMonthlyCart(
      BuildContext context, String monthlyCartName) async {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    String msg = await bloc.onClickMonthlyCartButton(monthlyCartName);
    showInSnackBar(msg, context);
  }
}
