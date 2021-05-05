import 'package:auto_buy/screens/expense_tracker/expense_tracker_screen.dart';
import 'package:auto_buy/screens/friends/friends_screen.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/homepage_products_screen.dart';
import 'package:auto_buy/screens/monthly_supplies/monthly_supplies_screen.dart';
import 'package:auto_buy/screens/my_orders/my_orders_screen.dart';
import 'package:auto_buy/screens/shopping_cart/shopping_cart_screen.dart';
import 'package:auto_buy/screens/user_account/user_account_screen.dart';
import 'package:auto_buy/screens/wishlist/wishlist_screen.dart';
import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
        context,
        hasLeading: false,
      ),
      drawer: _drawer(context),
      body: HomePageProducts(),
    );
  }
}

Widget _drawer(BuildContext context) {
  final auth = Provider.of<FirebaseAuthService>(context, listen: false);
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.menu_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Main Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
        ),
        customTextStle(
            'Expense Tracker',
            Icon(
              Icons.analytics_sharp,
              color: Colors.green,
              size: 30,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ExpenseTrackerScreen(),
                ),
              );
            }),
        customTextStle(
            'Monthly Supplies',
            Icon(
              Icons.calendar_today_outlined,
              color: Colors.orange,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => MonthlySuppliesScreen(),
                ),
              );
            }),
        customTextStle(
            'My WishList',
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => WishListScreen(),
                ),
              );
            }),
        customTextStle(
            'Shopping Cart',
            Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.blue,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ShoppingCartScreen(),
                ),
              );
            }),
        customTextStle(
            'User Account',
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => UserAccountScreen(),
                ),
              );
            }),
        customTextStle(
            'Friends',
            Icon(
              Icons.people,
              color: Colors.black,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => FriendsScreen(),
                ),
              );
            }),
        customTextStle(
            'My Orders',
            Icon(
              Icons.list_alt,
              color: Colors.purpleAccent,
            ),
            () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => MyOrdersScreen(),
                ),
              );
            }),
        customTextStle(
            'LogOut',
            Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
                () {
                auth.signOut();
                }),
      ],
    ),
  );
}

Widget customTextStle(String text, Widget icon, VoidCallback onTap) {
  return ListTile(
    title: Text(text),
    leading: icon,
    onTap: onTap,
  );
}


