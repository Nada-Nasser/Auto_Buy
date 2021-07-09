import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddDialog extends StatelessWidget {
 
  TextEditingController textController = new TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(child: new Text("Add Friend")),
      content: TextField(
        controller: textController,
        style: TextStyle(fontSize: 14.0),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Enter a Username#00000',
            icon: Icon(LineAwesomeIcons.user_plus, color: Colors.orange),
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(20.0),
              borderSide: new BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(20.0),
                borderSide: new BorderSide(
                  color: Colors.orange,
                ))),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        Row(
          children: <Widget>[
            new OutlineButton(
              child: new Text("Cancel"),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 4,
            ),
            new RaisedButton(
                onPressed: () {
                  validate(context,textController, auth);
                },
                child: new Text("ADD", style: TextStyle(color: Colors.white)),
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0))),
          ],
        ),
      ],
    );
  }

  validate(BuildContext context, TextEditingController controller, FirebaseAuthService auth) async {
    dynamic userToBeAdded;    /* An object that will contain all the information about the friend to be added */
    /* Get the friends of the current user */
    List<dynamic> friends = await CloudFirestoreService.instance.readOnceDocumentData(
      collectionPath: "users/", 
      documentId: auth.uid, 
      builder: (Map<String, dynamic> data,String documentId){
        return data['friends'];
        });
                             
    /* Check if there is an ID in the text box */
    if (controller.text.isEmpty) 
    {
      return errorDialog(context, "Please provide an ID");
    }else 
    {
      /* Get the user with that custom ID from the db */
      try {
        userToBeAdded = await CloudFirestoreService.instance.getCollectionData(
              collectionPath: "users/",
              queryBuilder: (query) => query.where('id', isEqualTo: controller.text),
              builder: (Map<String, dynamic> data, String documentId) {Map<String, dynamic> output = {"data": data,"docID": documentId};
                        return output;
              }).then((value) => value[0]);
            
        List<dynamic> requests = userToBeAdded['data']['requests'];
        /* Check if the provided id exists in the friends list of the user. */
        if(friends.contains(userToBeAdded['docID']))
        {
          return errorDialog(context, "This ID already exists in your friend list");
        }
        /* Check if there is a previous request has been sent to this ID */
        else if(requests.contains(auth.uid))
        {
          return infoDialog(context, "A request for this ID has already been sent");
        }else
        {
          /* Now we can add the user id in the request list of the user to be added. */
          requests.add(auth.uid);

          // Update requests.
          await CloudFirestoreService.instance.updateDocumentField(
          collectionPath: "users/",
          documentID: userToBeAdded['docID'],
          fieldName: 'requests',
          updatedValue: requests);

          return successDialog(context, "Your invitation has been sent successfully");
        }
      }catch (e) 
      {
        return errorDialog(context, "There is no user with this ID");
      }
    }
  }
}
