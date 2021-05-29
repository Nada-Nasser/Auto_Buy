import 'package:auto_buy/screens/product_info_screen/backend/product_info_screen_bloc.dart';
import 'package:auto_buy/screens/product_info_screen/backend/product_quantity_and_price_model.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuantityAndTotalPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return StreamBuilder<ProductQuantityAndPriceModel>(
        stream: bloc.productQuantityAndPriceModelStream,
        builder: (context, snapshot) {
          return _buildContent(context);
        });
  }

  Row _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityWidget(context),
        _buildTotalPriceWidget(context),
      ],
    );
  }

  Widget _buildTotalPriceWidget(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return Container(
      width: 0.50 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            "Total Price : ",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 0.040 * MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              "EGP ${bloc.totalPrice.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 0.05 * MediaQuery.of(context).size.width,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityWidget(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return Container(
      width: 0.40 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      // decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _decreasingButton(context),
          SizedBox(width: 10),
          _quantityWidget(bloc, context),
          SizedBox(width: 10),
          _increasingButton(context),
        ],
      ),
    );
  }

  GestureDetector _decreasingButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _decreaseQuantity(context),
      child: Text(
        "-",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 0.10 * MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Text _quantityWidget(ProductInfoScreenBloc bloc, BuildContext context) {
    return Text(
      "${bloc.quantity}",
      style: TextStyle(
        fontSize: 0.06 * MediaQuery.of(context).size.width,
      ),
    );
  }

  GestureDetector _increasingButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _increaseQuantity(context),
      child: Text(
        "+",
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
          fontSize: 0.09 * MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  void _increaseQuantity(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    bool flag = bloc.increaseQuantity();
    if (!flag) {
      showInSnackBar(bloc.increasingQuantityErrorMessage, context);
    }
  }

  void _decreaseQuantity(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    bool flag = bloc.decreaseQuantity();
    if (!flag) {
      showInSnackBar("You cannot buy less than 0 item", context);
    }
  }
}
