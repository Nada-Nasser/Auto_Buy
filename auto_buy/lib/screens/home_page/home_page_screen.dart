import 'package:auto_buy/screens/expense_tracker/expense_tracker_screen.dart';
import 'package:auto_buy/screens/friends/friends_screen.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/homepage_products_screen.dart';
import 'package:auto_buy/screens/monthly_supplies/monthly_carts_screen.dart';
import 'package:auto_buy/screens/my_orders/my_orders_screen.dart';
import 'package:auto_buy/screens/shopping_cart/shopping_cart_screen.dart';
import 'package:auto_buy/screens/user_account/user_account_screen.dart';
import 'package:auto_buy/screens/wishlist/wishlist_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Categories/backEnd/MainCategoryWidgets/main_categories_screen.dart';

class HomePage extends StatelessWidget {
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
    elevation: 10,
    child: SafeArea(
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
              ), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ExpenseTrackerScreen.create(context),
              ),
            );
          }),
          customTextStle(
              'Categories',
              Icon(
                Icons.category_sharp,
                color: Colors.orange,
                size: 30,
              ), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => Scaffold(body: mainCategScreen()),
              ),
            );
          }),
          customTextStle(
              'Monthly Supplies',
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.orange,
              ), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => MonthlyCartsScreen.create(context),
              ),
            );
          }),
          customTextStle(
              'My WishList',
              Icon(
                Icons.favorite,
                color: Colors.red,
              ), () {
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
              ), () {
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
              ), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => Profile(),
              ),
            );
          }),
          customTextStle(
              'Friends',
              Icon(
                Icons.people,
                color: Colors.black,
              ), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => AllScreens(),
              ),
            );
          }),
          customTextStle(
              'My Orders',
              Icon(
                Icons.list_alt,
                color: Colors.purpleAccent,
              ), () {
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
              ), () {
            auth.signOut();
          }),
        ],
      ),
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
