import 'dart:io';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  String governorate , initGovernorate;
  /*Static List that contains all governorates of egypt to allow the user to choose one of them */
  List listItem = ['Al Sharqia', 'Alexandria', 'Aswan', 'Asyut', 'Behira', 'Beni Suef', 'Cairo', 'Dakahlia', 'Damietta', 'Faiyum', 'Gharbia', 'Giza', 'Ismalia',
    'Kafr el-Sheikh', 'Luxor', 'Matruh', 'Minya', 'Monufia', 'New Valley', 'North Sinai', 'Port Said', 'Qalyubia', 'Qena', 'Red Sea', 'Sohag',
    'South Sinai', 'Suez'];


  File _image;
  final picker = ImagePicker();

  /* Function that allows the user to choose image, either from gallery or camera, and also offers the cropping featurre. */
  Future getImage(ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);

    setState(() {
      if (pickedFile != null) {
        _cropImage(pickedFile);
      } else {
        print("No image selected.");
      }
    });
  }

  _cropImage(final picked) async {
    File cropped = await ImageCropper.cropImage(
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.orange,
            toolbarTitle: "Crop image",
            toolbarWidgetColor: Colors.white),
        sourcePath: picked.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio3x2
        ],
        maxWidth: 800);
    if (cropped != null) {
      setState(() {
        _image = cropped;
      });
    }
  }


  /* This function is used to upload the selected image on the FireStore and also change the user's image */
  Future uploadPic(BuildContext context, FirebaseAuthService auth) async {
    String fileName = basename(_image.path);

    FirebaseStorage storage = FirebaseStorage.instance;

    //Create a reference to the location you want to upload to in firebase
    Reference ref = storage.ref().child("images/userImages/$fileName");

    //Upload the file to firebase
    UploadTask uploadTask = ref.putFile(_image);

    TaskSnapshot taskSnapShot = await uploadTask.whenComplete(() => null);

    updateUserImage(fileName, auth);
  }

  Future updateUserImage(String fileName, FirebaseAuthService auth) async {
    String newPath = "images/userImages/$fileName";
    await CloudFirestoreService.instance.updateDocumentField(
        collectionPath: "users/",
        documentID: auth.user.uid,
        fieldName: 'pic_path',
        updatedValue: newPath);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Edit Profile",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          /* This future builder is used to get user's data */
          child: StreamBuilder(
            stream: CloudFirestoreService.instance.documentStream(
                path: "users/${auth.uid}",
                builder: (Map<String, dynamic> data, String documentId) {
                  return data;
                }),
            builder: (ctx, snapShot) {
              if (snapShot.hasData) {
                /* inject the user's data into the textConrollers to allow the modification on them */
                TextEditingController nameController    = TextEditingController(text: snapShot.data['name']);
                TextEditingController cityController    = TextEditingController(text: ("${snapShot.data['adress']['city']}" != null ? "${snapShot.data['adress']['city']}" : ""));
                TextEditingController bNumberController = TextEditingController(text: ("${snapShot.data['adress']['building_number']}" != null ? "${snapShot.data['adress']['building_number']}" : ""));
                TextEditingController fNumberController = TextEditingController(text: ("${snapShot.data['adress']['floor_number']}" != null ? "${snapShot.data['adress']['floor_number']}" : ""));
                TextEditingController aNumberController = TextEditingController(text: ("${snapShot.data['adress']['apartment_number']}" != null ? "${snapShot.data['adress']['apartment_number']}" : ""));
                TextEditingController streetController  = TextEditingController(text: ("${snapShot.data['adress']['street']}" != null ? "${snapShot.data['adress']['street']}" : ""));
                TextEditingController numberController  = TextEditingController(text: snapShot.data['phone_number']);
                initGovernorate = snapShot.data['adress']['governorate'];
                print(initGovernorate);
                return ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          /* 
                              This future builder is used to get a url of the user's image by checking on the follwing:
                                  1- if the stored pic_path of the user doesn't contain (googleusercontent), this means
                                     that the user's image is stored in firesotre and we can get this image by the provided
                                     function.
                          */
                          FutureBuilder(
                            future: FirebaseStorageService.instance
                                .downloadURL(snapShot.data['pic_path']),
                            builder: (ctx, image) {
                              if (image.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                String pth;
                                if (snapShot.data['pic_path']
                                    .toString()
                                    .contains('googleusercontent')) {
                                  pth = snapShot.data['pic_path'];
                                } else {
                                  pth = image.data;
                                }
                                return Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color: Colors.black.withOpacity(0.2),
                                            offset: Offset(0, 10))
                                      ],
                                      shape: BoxShape.circle,
                                      image: (_image == null)
                                          ? DecorationImage(fit: BoxFit.cover, image: NetworkImage(pth))
                                          : DecorationImage(image: new FileImage(_image), fit: BoxFit.fill)
                                  ),
                                );
                              }
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                  Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.orange[400],
                              ),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  /* This alert dialog is used to give the user the optionality of choosing his new image either from camera or gallery */
                                  var ad = AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    title: Text("Choose Picture frome: "),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          Divider(color: Colors.black),
                                          Container(
                                            width: 300,
                                            color: Colors.orange,
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.image,
                                                color: Colors.white,
                                              ),
                                              title: Text("Gallery",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () {
                                                getImage(ImageSource.gallery);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: 300,
                                            color: Colors.orange,
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white,
                                              ),
                                              title: Text("Camera",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () {
                                                getImage(ImageSource.camera);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ad;
                                      });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    buildTextFormField("Full Name",nameController),
                    buildTextFormField("Phone Number",numberController,limit: true),
                    Row(
                      children: [

                        Expanded(child: buildTextFormField("Apartment Number", aNumberController), flex: 1,),
                        SizedBox(width: 4,),
                        Expanded(child: buildTextFormField("Floor Number", fNumberController), flex: 1),
                        SizedBox(width: 4,),
                        Expanded(child: buildTextFormField("Building Number", bNumberController), flex: 1),
                      ],
                    ),
                    buildTextFormField("Street", streetController),
                    buildTextFormField("City", cityController),
                    buildDropDownMenu(initGovernorate),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        RaisedButton(
                          onPressed: () {
                            update(context, auth, nameController, bNumberController, cityController, streetController, aNumberController, fNumberController, numberController);
                          },
                          color: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("SAVE",style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Future update(BuildContext context, FirebaseAuthService auth,
      TextEditingController nameController, TextEditingController bNumberController,
      TextEditingController cityController, TextEditingController streetController,
      TextEditingController aNumberController, TextEditingController fNumberController, TextEditingController numberController) async{

    RegExp regExp = new RegExp(
      r"^(01)[1520][0-9]{8}$",
      caseSensitive: false,
      multiLine: false,
    );
    if(regExp.hasMatch(numberController.text)==false)
    {
      errorDialog(context, "Please make sure that your phone number is following one of these formats:\n\n012XXXXXXXX\n010XXXXXXXX\n011XXXXXXXX");
      return;
    }




    Map <String, dynamic> newAdress;
    String newGov;
    // Image.
    if(_image != null)
    {
      uploadPic(context, auth);
    }
    // Dealing with governorate.
    if(governorate == null)
    {
      newGov = initGovernorate;
    }else
    {
      newGov = governorate;
    }
    // Update name.
    await CloudFirestoreService.instance.updateDocumentField(
        collectionPath: "users/",
        documentID: auth.user.uid,
        fieldName: 'name',
        updatedValue: nameController.text);

    // Update number.
    await CloudFirestoreService.instance.updateDocumentField(
        collectionPath: "users/",
        documentID: auth.user.uid,
        fieldName: 'phone_number',
        updatedValue: numberController.text);

    newAdress = {"building_number" : bNumberController.text, "city" : cityController.text, "street" : streetController.text, "governorate" : newGov, "apartment_number" : aNumberController.text, "floor_number" : fNumberController.text};

    // Update adress.
    await CloudFirestoreService.instance.updateDocumentField(
        collectionPath: "users/",
        documentID: auth.user.uid,
        fieldName: 'adress',
        updatedValue: newAdress);
    showInSnackBar("Your data updated successfuly", context);
  }

  Widget buildTextFormField(String labelText, TextEditingController cont,{bool limit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        style: TextStyle(fontSize: 13.0, color: Colors.black),
        maxLength: limit==true?11:500,
        controller: cont,
        decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            labelText: labelText,
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(
                  color: Colors.orange,
                ))

        ),
      ),
    );
  }
  Widget  buildDropDownMenu(String ingov)
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField(
        style: TextStyle(fontSize: 13.0, color: Colors.black),
        hint: (ingov == null || ingov =="") ? "Governorate" : Text(ingov),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),

          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(
              color: Colors.grey,
            ),
          ),

        ),

        dropdownColor: Colors.white,

        icon: Icon(Icons.arrow_drop_down, color: Colors.orange),
        iconSize: 36,

        value: governorate,
        onChanged: (newValue){
          governorate = newValue;
        },
        items: listItem.map((valueItem){
          return DropdownMenuItem(

            value: valueItem,
            child: Text(valueItem),
          );
        }).toList(),
      ),
    );

  }
}