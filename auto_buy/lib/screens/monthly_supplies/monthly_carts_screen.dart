import 'package:auto_buy/screens/monthly_supplies/widgets/adding_new_cart_dialog.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'monthly_carts_bloc.dart';
import 'monthly_supplies_screen.dart';

class MonthlyCartsScreen extends StatefulWidget {
  final MonthlyCartsBloc bloc;

  const MonthlyCartsScreen({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Provider<MonthlyCartsBloc>(
      create: (_) => MonthlyCartsBloc(
        uid: auth.uid,
      ),
      child: Consumer<MonthlyCartsBloc>(
        builder: (_, bloc, __) => MonthlyCartsScreen(bloc: bloc),
      ),
    );
  }

  @override
  _MonthlyCartsScreenState createState() => _MonthlyCartsScreenState();
}

class _MonthlyCartsScreenState extends State<MonthlyCartsScreen> {
  @override
  void initState() {
    widget.bloc.fetchUserMonthlyCarts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MonthlyCartsBloc>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: customAppBar(context),
      body: Column(
        children: [
          buildCartName(),
          Expanded(
            child: StreamBuilder(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: GridView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1, crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          if (index <
                              bloc.monthlyCartsScreenModel
                                  .numberOfMonthlyCarts) {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) =>
                                        MonthlySuppliesScreen.create(
                                            context,
                                            bloc.monthlyCartsScreenModel
                                                .monthlyCarts[index].name),
                                  ),
                                );
                              },
                              onLongPress: () {
                                addNewCartDialog(
                                  context,
                                  "Edit/Delete Monthly Cart",
                                  "You can edit the starting delivery date by selecting a new one",
                                  bloc,
                                  cartName: bloc.monthlyCartsScreenModel
                                      .monthlyCarts[index].name,
                                  date: bloc.monthlyCartsScreenModel
                                      .monthlyCarts[index].deliveryDate,
                                  editCart: true,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: _boxDecorationNoBorders(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.deepOrangeAccent,
                                      size: 100,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${bloc.monthlyCartsScreenModel.monthlyCarts[index].name}",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.open_in_new,
                                            color: Colors.grey[600],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                final bloc = Provider.of<MonthlyCartsBloc>(
                                    context,
                                    listen: false);
                                addNewCartDialog(
                                    context,
                                    "New Monthly Cart",
                                    "Write a new cart name and select delivery date you want",
                                    bloc);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                decoration: _boxDecorationNoBorders(),
                                child: Center(
                                  child: Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: Colors.grey[300],
                                    size:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecorationNoBorders() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 1.0,
        ),
      ],
    );
  }

  Container buildCartName() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.orange),
          SizedBox(
            width: 5,
          ),
          Text(
            "Monthly Carts",
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
