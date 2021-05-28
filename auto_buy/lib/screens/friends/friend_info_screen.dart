import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FriendInfo extends StatefulWidget {
  Map<String, dynamic> friend;          /*  This map will hold the details of the friend the the user had pressed on his card   */
  String pth;                          /*   Hold the path of the friend's image                                                */
  String friendId;                    /*    This string will hold the ID of the friend the the user had pressed on his card   */
  List<dynamic> friends;             /*     This list will hold the ID's of the user's friends                               */
  FriendInfo(Map<String, dynamic> friend, String pth, String friendId,
      List<dynamic> friends) {
    this.friend = friend;
    this.pth = pth;
    this.friendId = friendId;
    this.friends = friends;
  }
  @override
  _FriendInfoState createState() => _FriendInfoState();
}

class _FriendInfoState extends State<FriendInfo> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Info', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.pth)))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                widget.friend['name'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 0.5,
              color: Colors.black38,
              thickness: 0.5,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  onPressed: () {
                    /*
                    we have to deligate the user to a screen that contains the wish list of the selected user.
                    */
                  },
                  color: Colors.orange,
                  padding:
                      EdgeInsets.only(left: 50, top: 20, right: 50, bottom: 15),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Send a gift", style: TextStyle(fontSize: 25)),
                      SizedBox(width: 30),
                      Icon(
                        LineAwesomeIcons.gift,
                        size: 25,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    _showDialog(
                      context,
                      auth,
                    );
                  },
                  color: Colors.orange,
                  padding:
                      EdgeInsets.only(left: 50, top: 20, right: 50, bottom: 15),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Remove friend", style: TextStyle(fontSize: 25)),
                      SizedBox(width: 30),
                      Icon(
                        Icons.person_remove_rounded,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(
    BuildContext context,
    FirebaseAuthService auth,
  ) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        widget.friends.remove(widget.friendId);
        await CloudFirestoreService.instance.updateDocumentField(
            collectionPath: "users/",
            documentID: auth.user.uid,
            fieldName: 'friends',
            updatedValue: widget.friends);
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          title: new Text("Warning"),
          content: new Text("Are you sure about removing " +
              widget.friend['name'] +
              " from your friend list?"),
          actions: <Widget>[cancelButton, continueButton],
        );
      },
    );
  }
}
