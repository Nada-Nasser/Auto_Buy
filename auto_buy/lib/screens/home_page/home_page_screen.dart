import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [FlatButton(onPressed: auth.signOut, child: Text("Logout"))],
      ),
      drawer: _drawer(),

    );
  }
}

Widget _drawer(){
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
                  Text('Main Menu',
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
        customTextStle('Expense Tracker',
            Icon(
              Icons.analytics_sharp,
              color: Colors.green,
              size: 30,
            ),
            (){}
        ),
        customTextStle('Monthly Supplies',
            Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            ),
                (){}
        ),
        customTextStle('My WishList',
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
                (){}
        ),
        customTextStle('Shopping Cart',
            Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.blue,
            ),
                (){}
        ),
        customTextStle('User Account',
            Icon(
              Icons.person,
              color: Colors.black,
            ),
                (){}
        ),
        customTextStle('Friends',
            Icon(
              Icons.people,
              color: Colors.black,
            ),
                (){}
        ),
        customTextStle('My Orders',
            Icon(
              Icons.list_alt,
              color: Colors.amber,
            ),
                (){}
        ),
      ],
    ),
  );
}

Widget customTextStle(String text,Widget icon,VoidCallback onTap){
  return ListTile(
    title: Text(text),
    leading:icon,
    onTap: onTap,
  );
}
