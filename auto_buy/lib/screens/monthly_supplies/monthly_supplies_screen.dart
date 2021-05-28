import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/adding_new_cart_dialog.dart';
import 'package:auto_buy/screens/monthly_supplies/widgets/monthly_cart_names_selection_widget.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///D:/Documents/FCI/Y4T2/Graduation%20Project/Implementation/auto_buy/lib/widgets/products_grid_view/products_grid_view.dart';

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
          mainAxisSize: MainAxisSize.max,
          children: [
            buildCartName(),
            StreamBuilder<String>(
                stream: bloc.selectedCartNameStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ProductsGridView(
                        products: bloc.monthlyCartProducts,
                        quantities: bloc.quantities,
                        onTap: _onTapProduct,
                        onLongPress: _onLongPressProduct,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: Center(
                        child: Text(
                          "Error has occured",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: Center(
                        child: Text(
                          "Select Monthly Cart Name",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  }
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

  _onTapProduct(BuildContext context, Product product) {
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

  Future<void> _onLongPressProduct(
      BuildContext context, Product product) async {
    int q = bloc.getProductQuantityInTheCart(product.id);
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("${product.name}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "You can delete this product from your ${bloc.selectedCartName} monthly cart",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      await bloc.deleteProduct(product.id);
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Delete"),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "or",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "update the quantity you want from this product",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => {
                          setState(() {
                            if (q > 0)
                              q--;
                            else {
                              showInSnackBar(
                                  "Quantity can not be less than zero",
                                  context);
                            }
                          })
                        },
                        child: Text(
                          "-",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 0.10 * MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      Text("$q"),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => setState(() {
                          q++;
                        }),
                        child: Text(
                          "+",
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 0.09 * MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (q == 0) {
                        await bloc.deleteProduct(product.id);
                        Navigator.of(context).pop(true);
                      } else {
                        await bloc.updateProductQuantityInSelectedMonthlyCart(
                            product.id, q);
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Text("update"),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("cancel"),
                ),
              ],
            );
          });
        });
  }
}
