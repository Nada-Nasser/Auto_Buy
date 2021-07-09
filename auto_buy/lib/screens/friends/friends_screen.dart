import 'package:auto_buy/screens/friends/add_friend.dart';

import 'requests_list.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'friends_list.dart';


class AllScreens extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
       return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.white,
              tabs: [Tab(text: 'My Friends'), Tab(text: 'Requests')],
            ),
            title: Text('Friends', style: TextStyle(color: Colors.white)),
            elevation: 0.1,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  LineAwesomeIcons.user_plus,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddDialog(),
                  );
                },
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: TabBarView(
            children: [FriendsList(), RequestsList(_scaffoldKey)],
          ),
      ),
    );
  }
}
