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
      margin: const EdgeInsets.fromLTRB(4, 5, 4, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _addToCartButton(
            context: context,
            text: "Add To Shopping Cart",
            icon: Icons.shopping_cart_sharp,
            onTap: (context) => onClickShoppingCartButton(context),
            backgroundColor: Colors.indigoAccent[100],
            textColor: Colors.white,
            iconColor: Colors.amber,
          ),
          SizedBox(
            height: 20,
          ),
          _addToCartButton(
              context: context,
              text: "Add To Monthly Cart",
              icon: Icons.calendar_today_sharp,
              onTap: (context) => _onClickMonthlyCartButton(context),
              backgroundColor: Colors.yellow[700],
              textColor: Colors.white,
              iconColor: Colors.black54),
        ],
      ),
    );
  }

  Widget _addToCartButton({
    BuildContext context,
    String text,
    IconData icon,
    Future<void> Function(BuildContext context) onTap,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black45,
    Color iconColor,
  }) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 0.07 * MediaQuery.of(context).size.width,
        color: iconColor,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 0.045 * MediaQuery.of(context).size.width,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () => onTap(context),
      style: ElevatedButton.styleFrom(
        elevation: 5,
        primary: backgroundColor,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      ),
    );
  }

  Future<void> onClickShoppingCartButton(BuildContext context) async {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    String msg = await bloc.onClickShoppingCartButton();
    showInSnackBar(msg, context);
  }

  Future<void> _onClickMonthlyCartButton(BuildContext context) async {
    /// step 1 : Select Monthly Cart name from Dialog?
    /// step 2 : add The Product To Monthly Cart
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    List<String> names = await bloc.getMonthlyCartsNames();
    print(names);
    await selectionDialog(
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
