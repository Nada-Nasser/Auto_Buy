import 'package:auto_buy/screens/friends/add_friend.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/widgets/users_list_dialog.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'command.dart';

class FriendCommand implements Command {
  final CommandArguments commandArguments;
  FriendCommand(this.commandArguments);

  @override
  // TODO: implement isValidCommand
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;

  @override
  Future<void> run() async {
    // TODO: implement run
    if (commandArguments.commandType == CommandType.ADD) {
      await _addFriend();
    } else if (commandArguments.commandType == CommandType.DELETE) {
      await _deleteFriend();
    } else {
      throw UnimplementedError();
    }
  }

  Future<void>_addFriend() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      return await showDialog(
          context: commandArguments.context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AddDialog();
            });
          });
    });

  }

  Future<void> _deleteFriend() async {
    //get the user's data
    dynamic userData = await CloudFirestoreService.instance.readOnceDocumentData(collectionPath: "users/", documentId: commandArguments.uid, builder: (data, documentId) {
      return data;
    });
    //get the user's friends
    List<dynamic> userFriends = userData['friends'];

    await userListDialog(commandArguments.context,commandArguments.uid,userFriends,'Choose some one to delete');



  }

  Future<void >_onClick(BuildContext contextm){

  }

  validate(BuildContext context, TextEditingController controller,
      String uid) async {
    dynamic
        userToBeAdded; /* An object that will contain all the information about the friend to be added */
    /* Get the friends of the current user */
    List<dynamic> friends =
        await CloudFirestoreService.instance.readOnceDocumentData(
            collectionPath: "users/",
            documentId: uid,
            builder: (Map<String, dynamic> data, String documentId) {
              return data['friends'];
            });

    /* Check if there is an ID in the text box */
    if (controller.text.isEmpty) {
      return errorDialog(context, "Please provide an ID");
    } else {
      /* Get the user with that custom ID from the db */
      try {
        userToBeAdded = await CloudFirestoreService.instance
            .getCollectionData(
                collectionPath: "users/",
                queryBuilder: (query) =>
                    query.where('id', isEqualTo: controller.text),
                builder: (Map<String, dynamic> data, String documentId) {
                  Map<String, dynamic> output = {
                    "data": data,
                    "docID": documentId
                  };
                  return output;
                })
            .then((value) => value[0]);

        List<dynamic> requests = userToBeAdded['data']['requests'];
        /* Check if the provided id exists in the friends list of the user. */
        if (friends.contains(userToBeAdded['docID'])) {
          return errorDialog(
              context, "This ID already exists in your friend list");
        }
        /* Check if there is a previous request has been sent to this ID */
        else if (requests.contains(uid)) {
          return infoDialog(
              context, "A request for this ID has already been sent");
        } else {
          /* Now we can add the user id in the request list of the user to be added. */
          requests.add(uid);

          // Update requests.
          await CloudFirestoreService.instance.updateDocumentField(
              collectionPath: "users/",
              documentID: userToBeAdded['docID'],
              fieldName: 'requests',
              updatedValue: requests);

          return successDialog(
              context, "Your invitation has been sent successfully");
        }
      } catch (e) {
        return errorDialog(context, "There is no user with this ID");
      }
    }
  }
}
