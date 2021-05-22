import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/adding_new_cart_dialog.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/monthly_cart_names_selection_widget.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/products_grid_view.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'monthly_carts_screen_bloc.dart';

class MonthlySuppliesScreen extends StatelessWidget {
  final MonthlyCartsScreenBloc bloc;

  //List<Product> products = [];
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
    List<Widget> content = [
      CartNameDropDownButton(),
      StreamBuilder<String>(
          stream: bloc.selectedCartNameStream,
          builder: (context, snapshot) {
            return ProductsGridView(
              products: bloc.monthlyCartProducts,
            );
          }),
    ];

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      appBar: customAppBar(context),
      body: buildContent(content),
    );
  }

  Container buildContent(List<Widget> content) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ListView.builder(
          itemCount: content.length,
          itemBuilder: (BuildContext context, int index) {
            return content[index];
          },
        ),
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
}
