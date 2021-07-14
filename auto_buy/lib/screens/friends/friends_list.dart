import 'package:auto_buy/screens/friends/friend_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
       return Container(
        padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
        child: Center(
          child: StreamBuilder(
            stream: CloudFirestoreService.instance.documentStream(
                path: "users/${auth.uid}",
                builder: (Map<String, dynamic> data, String documentId) {
                  return data;
                }),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                List<dynamic> friends = snapShot.data['friends'];
                if(friends.length == 0)
                {
                  return Text("You do not have a friend? Optio can be your friend 🥰");
                }
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
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
                                            text: snapShot.data['id'],
                                            style:
                                                TextStyle(color: Colors.black, fontSize: 12),
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
      );
    
  }
}