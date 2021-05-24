import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/adding_new_cart_dialog.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/monthly_cart_names_selection_widget.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/products_grid_view.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'monthly_carts_screen_bloc.dart';

class MonthlySuppliesScreen extends StatelessWidget {
  final MonthlyCartsScreenBloc bloc;

  MonthlySuppliesScreen({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Provider<MonthlyCartsScreenBloc>(
      create: (_) => MonthlyCartsScreenBloc(
        uid: auth.uid,
      ),
      child: Consumer<MonthlyCartsScreenBloc>(
        builder: (_, bloc, __) => MonthlySuppliesScreen(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _buildFloatingActionButton(context),
        appBar: customAppBar(context),
        body: Column(
          children: [
            buildCartName(),
            StreamBuilder<String>(
                stream: bloc.selectedCartNameStream,
                builder: (context, snapshot) {
                  return Expanded(
                    child: ProductsGridView(
                      products: bloc.monthlyCartProducts,
                      quantities: bloc.quantities,
                      onTap: onTapProduct,
                      onLongPress: onLongPressProduct,
                    ),
                  );
                }),
          ],
        ));
  }

  Container buildCartName() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.orange),
              SizedBox(
                width: 5,
              ),
              Text(
                "Monthly Carts",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CartNameDropDownButton(),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        addNewCartDialog(context, "New Monthly Cart",
            "Write a new cart name and select delivery date you want", bloc);
      },
      label: Text('Add New Cart'),
      icon: Icon(Icons.add),
    );
  }

  onTapProduct(BuildContext context, Product product) {
    //  Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductInfoScreen.create(
          context,
          product,
          product.picturePath,
        ),
      ),
    );
  }

  Future<void> onLongPressProduct(BuildContext context, Product product) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Deleting Product"),
            content: Text(
                "Are you sure you want to delete this product from your ${bloc.selectedCartName} monthly cart"),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("cancel"),
              ),
              FlatButton(
                onPressed: () async {
                  await bloc.deleteProduct(product.id);
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes, delete"),
              ),
            ],
          );
        });
  }
}
