import 'package:auto_buy/screens/friends/add_friend.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'requests_list.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'friends_list.dart';

class AllScreens extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int numOfReq;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'My Friends'),
              StreamBuilder(
                stream: CloudFirestoreService.instance.documentStream(
                    path: "users/${auth.uid}",
                    builder: (Map<String, dynamic> data, String documentId) {
                      return data;
                    }),
                builder: (ctx, mySnapShot) 
                {
                  if (!mySnapShot.hasData) 
                  {
                    return CircularProgressIndicator();
                  } else 
                  {
                    numOfReq = mySnapShot.data['requests'].length;
                    return Badge(
                      position: BadgePosition.topEnd(top: 12, end: -23),
                      badgeContent:
                          Text('$numOfReq', style: TextStyle(fontSize: 10)),
                      badgeColor: Colors.orange[50],
                      showBadge: numOfReq == 0 ? false : true,
                      child: Tab(text: 'Requests'),
                    );
                  }
                },
              ),
            ],
          ),
          title: Text('Friends', style: TextStyle(color: Colors.white)),
          elevation: 0.1,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
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
