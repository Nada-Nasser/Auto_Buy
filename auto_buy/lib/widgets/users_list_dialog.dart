import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/vertical_list_view/vertical_products_list_view.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/material.dart';

Future<void> userListDialog(
    BuildContext screenContext,
    // Future<void> Function(BuildContext context, Product product) onClickDone,
    String uid,
    List<dynamic> userIds,
    String title,
    ) async {
  double width = MediaQuery.of(screenContext).size.width;
  double height = MediaQuery.of(screenContext).size.height;

  return await showDialog(
      useSafeArea: true,
      context: screenContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                //scrollable: true,
                title: new Text(title),
                content: Container(
                  width: width,
                  height: height * 0.9,
                  child: ListView.builder(
                    itemCount: userIds.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: CloudFirestoreService.instance.readOnceDocumentData(collectionPath: 'users/', documentId: "${userIds[index]}", builder: (data, documentId) {
                          dynamic output = {'id':documentId,'data':data};
                          return output;
                        },),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            Map<String, dynamic> friend = snapshot.data['data'];          /*  This map will hold the details of the friend the the user had pressed on his card   */
                            String pth;                          /*   Hold the path of the friend's image                                                */
                            String friendId = snapshot.data['id'];                    /*    This string will hold the ID of the friend the the user had pressed on his card   */
                            List<dynamic> friends = userIds;
                            return GestureDetector(
                              onTap: (){
                                confirmationDialog(
                                    context, "Are you sure about removing " + friend['name'] + " from your friend list?",
                                    positiveText: "Delete",
                                    title: "Warning",
                                    positiveAction: () async{

                                      /* Remove the selected user from the friends list of the current user */
                                      friends.remove(friendId);

                                      /* Remove the current user from the friend list of the user being removed */
                                      List <dynamic> hisFriends = await CloudFirestoreService.instance.readOnceDocumentData(
                                          collectionPath: "users/",
                                          documentId: friendId,
                                          builder: (Map<String, dynamic> data,String documentId)
                                          {
                                            return data['friends'];
                                          }
                                      );
                                      print("hisFriend $hisFriends");
                                      print("my id $uid");
                                      hisFriends.remove(uid);

                                      /*Now update the fields of bothe users */
                                      await CloudFirestoreService.instance.updateDocumentField(
                                          collectionPath: "users/",
                                          documentID: uid,
                                          fieldName: 'friends',
                                          updatedValue: friends);

                                      await CloudFirestoreService.instance.updateDocumentField(
                                          collectionPath: "users/",
                                          documentID: friendId,
                                          fieldName: 'friends',
                                          updatedValue: hisFriends);
                                      Navigator.of(context).pop();
                                    }
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                key: ValueKey(snapshot.data['data']['name']),
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
                                        tag: "avatar_" + snapshot.data['data']['name'],
                                        child: FutureBuilder(
                                          future: FirebaseStorageService.instance
                                              .downloadURL(
                                              snapshot.data['data']['pic_path']),
                                          builder: (ctx, image) {
                                            if (image.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else {
                                              if (snapshot.data['data']['pic_path']
                                                  .toString()
                                                  .contains('googleusercontent')) {
                                                pth = snapshot.data['data']['pic_path'];
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
                                      snapshot.data['data']['name'],
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
                                                    text: snapshot.data['data']['id'],
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
                                  ),
                                ),
                              ),
                            );
                          }else{
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            });
      });
}
