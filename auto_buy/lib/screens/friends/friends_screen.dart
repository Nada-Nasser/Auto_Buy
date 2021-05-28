import 'package:auto_buy/screens/friends/friend_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class AllScreens extends StatefulWidget {
  @override
  _AllScreensState createState() => _AllScreensState();
}

class _AllScreensState extends State<AllScreens> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
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
                  _showDialog(context);
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
            children: [FriendList(), RequestList()],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          title: Text("Add friend"),
          
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -15,
                top: -55,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(LineAwesomeIcons.user_plus, color: Colors.orange),
                            labelText: 'User ID'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("ADD", style: TextStyle(color: Colors.white)),
                        color: Colors.orange,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class RequestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            body: Center(
                child: Text(
      'Second Activity Screen',
      style: TextStyle(fontSize: 21),
    ))));
  }
}

class FriendList extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
        child: Center(
          child: FutureBuilder(
            future: CloudFirestoreService.instance.readOnceDocumentData(
                collectionPath: "users/",
                documentId: auth.uid,
                builder: (Map<String, dynamic> data, String documentId) {
                  return data;
                }),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                List<dynamic> friends = snapShot.data['friends'];
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (_, index) {
                    return FutureBuilder(
                      future: CloudFirestoreService.instance
                          .readOnceDocumentData(
                              collectionPath: "users/",
                              documentId: friends[index],
                              builder: (Map<String, dynamic> data,
                                  String documentId) {
                                return data;
                              }),
                      builder: (context, snapShot) {
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          String pth;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            key: ValueKey(snapShot.data['name']),
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      right: new BorderSide(
                                          width: 1.0,
                                          color: Colors.orange[200]),
                                    ),
                                  ),
                                  child: Hero(
                                    tag: "avatar_" + snapShot.data['name'],
                                    child: FutureBuilder(
                                      future: FirebaseStorageService.instance
                                          .downloadURL(
                                              snapShot.data['pic_path']),
                                      builder: (ctx, image) {
                                        if (image.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else {
                                          if (snapShot.data['pic_path']
                                              .toString()
                                              .contains('googleusercontent')) {
                                            pth = snapShot.data['pic_path'];
                                          } else {
                                            pth = image.data;
                                          }
                                          return CircleAvatar(
                                            radius: 32,
                                            backgroundImage: NetworkImage(pth),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapShot.data['name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  children: [
                                    new Flexible(
                                        child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: friends[index],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          maxLines: 3,
                                          softWrap: true,
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.black, size: 30.0),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => FriendInfo(
                                          snapShot.data,
                                          pth,
                                          friends[index],
                                          friends),
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
