import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/cart_checkout_screen/cart_checkout_screen.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/products_grid_view/products_grid_view.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_supplies_screen_bloc.dart';

class MonthlySuppliesScreen extends StatefulWidget {
  final MonthlyCartsScreenBloc bloc;
  final String cartName;

  MonthlySuppliesScreen({Key key, this.bloc, this.cartName}) : super(key: key);

  static Widget create(BuildContext context, String cartName) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Provider<MonthlyCartsScreenBloc>(
      create: (_) => MonthlyCartsScreenBloc(
        uid: auth.uid,
        selectedCartName: cartName,
      ),
      child: Consumer<MonthlyCartsScreenBloc>(
        builder: (_, bloc, __) => MonthlySuppliesScreen(
          bloc: bloc,
          cartName: cartName,
        ),
      ),
    );
  }

  @override
  _MonthlySuppliesScreenState createState() => _MonthlySuppliesScreenState();
}

class _MonthlySuppliesScreenState extends State<MonthlySuppliesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        body: StreamBuilder<bool>(
            stream: widget.bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingImage();
              }
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  buildHeader(),
                  Expanded(
                    child: ProductsGridView(
                      products: widget.bloc.monthlyCartProducts,
                      quantities: widget.bloc.quantities,
                      onTap: _onTapProduct,
                      onLongPress: widget.bloc.isCheckedOut? null : _onLongPressProduct,
                    ),
                  ),
                  widget.bloc.isCheckedOut ? ElevatedButton(
                    child: Text("Cancel Monthly Cart Order"),
                  )
                      :ElevatedButton(
                      onPressed: () {  // CHECK OUT button
                        if (!widget.bloc.monthlyCartProducts.isEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CartCheckoutScreen(
                                    cartPath: widget.bloc.selectedCartName,
                                    orderPrice: widget.bloc.totalPrice,
                                    isMonthlyCart: true,
                                    productIDs: widget.bloc.productIDs,
                                    productIdsAndQuantity: widget.bloc.productIdsAndQuantity,
                                   productIdsAndPrices: widget.bloc.productIdsAndPrices,
                                  ))
                          ).then((value) =>  Navigator.of(context).pop(false));
                        } else
                          showInSnackBar(
                              "You need to add items first!", context);
                      },
                      child: Text("Check Out")
                  )
                ],
              );
            }));
  }

  Container buildHeader() {
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
          Row(
            children: [Text("Total Price = \$${widget.bloc.totalPrice.toStringAsFixed(3)}")],
          ),
        ],
      ),
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
    int q = widget.bloc.getProductQuantityInTheCart(product.id);
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
                    "You can delete this product from your ${widget.bloc.selectedCartName} monthly cart",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.bloc.deleteProduct(product.id);
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
                          if (q < product.maxDemandPerUser)
                            q++;
                          else
                            showInSnackBar(
                                "You can't add more than $q ${product.name} in the cart",
                                context);
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
                        await widget.bloc.deleteProduct(product.id);
                        Navigator.of(context).pop(true);
                      } else {
                        await widget.bloc.updateProductQuantityInSelectedMonthlyCart(
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
                  child: Text("Close"),
                ),
              ],
            );
          });
        });
  }
}
