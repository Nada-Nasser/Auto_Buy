import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  RequestsList(this.scaffoldKey);

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
            builder: (ctx, mySnapShot) {
              if (!mySnapShot.hasData) {
                return CircularProgressIndicator();
              } else {
                List<dynamic> requests = mySnapShot.data['requests'];
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: CloudFirestoreService.instance
                          .readOnceDocumentData(
                              collectionPath: "users/",
                              documentId: requests[index],
                              builder: (Map<String, dynamic> data,
                                  String documentId) {
                                return data;
                              }),
                      builder: (context, snapShot) {
                        if (!snapShot.hasData) {
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
                                                .contains(
                                                    'googleusercontent')) {
                                              pth = snapShot.data['pic_path'];
                                            } else {
                                              pth = image.data;
                                            }
                                            return CircleAvatar(
                                              radius: 32,
                                              backgroundImage:
                                                  NetworkImage(pth),
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
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            maxLines: 3,
                                            softWrap: true,
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                  trailing: Wrap(
                                    spacing: 12, // space between two icons
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Icon(Icons.check_circle_outline, color: Colors.green, size: 30),
                                        onTap: () async {
                                            /* Add the ID in the request list to the friend list of that user */
                                            int removedRequest = index;
                                            
                                            List<dynamic> myFriends = mySnapShot.data['friends'];
                                            myFriends.add(requests[index]);
                                            
                                            /* Add the current user in the friend list of the user being in request list */
                                            
                                            List <dynamic> hisFriends = await CloudFirestoreService.instance.readOnceDocumentData(
                                              collectionPath: "users/",
                                              documentId: requests[index],
                                              builder: (Map<String, dynamic> data,String documentId)
                                              {
                                                return data['friends'];
                                              }
                                            );
                                            hisFriends.add(auth.uid);
                                            /* Update the friends of the current user */
                                             await CloudFirestoreService.instance.updateDocumentField
                                             (
                                               collectionPath: "users/",
                                               documentID: auth.uid,
                                               fieldName: 'friends',
                                               updatedValue: myFriends
                                             );

                                             /* Update the friends list of the user who invited */
                                             await CloudFirestoreService.instance.updateDocumentField
                                             (
                                               collectionPath: "users/",
                                               documentID: requests[index],
                                               fieldName: 'friends',
                                               updatedValue: hisFriends
                                             );

                                             /* Update the requests of the current user */
                                              requests.removeAt(removedRequest);
                                              await CloudFirestoreService.instance.updateDocumentField
                                              (
                                                  collectionPath: "users/",
                                                  documentID: auth.uid,
                                                  fieldName: 'requests',
                                                  updatedValue: requests
                                              );
                                              successDialog(this.scaffoldKey.currentContext, "Congratulations, you are now friends");
                                        }
                                      ),
                                      GestureDetector(
                                        child: Icon(Icons.cancel_outlined, color: Colors.red, size: 30),
                                        onTap: ()async{
                                          int removedRequest = index;
                                              /* Update the requests of the current user */
                                              requests.removeAt(removedRequest);
                                              await CloudFirestoreService.instance.updateDocumentField
                                              (
                                                  collectionPath: "users/",
                                                  documentID: auth.uid,
                                                  fieldName: 'requests',
                                                  updatedValue: requests
                                              );
                                        },
                                      ),
                                    ],
                                  )
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
