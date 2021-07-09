import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/cart_checkout_screen/payment_screen.dart';
import 'package:auto_buy/screens/monthly_supplies/cart_supplies_screen_bloc.dart';
import 'package:auto_buy/screens/monthly_supplies/monthly_carts_bloc.dart';
import 'package:auto_buy/screens/user_account/User_Settings.dart';
import 'package:auto_buy/screens/user_account/user_account_screen.dart';
import 'package:auto_buy/services/checkingOutServices.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartCheckoutScreen extends StatefulWidget {
  CartCheckoutScreen({
    this.cartPath,
    @required this.productIDs,
    @required this.orderPrice,
    this.isMonthlyCart = false,
  });

  // final List<Product> products;
  final String cartPath;
  final double orderPrice;
  final bool isMonthlyCart;
  final List<String> productIDs;
  bool enabledEditing = false;

  @override
  _CartCheckoutScreenState createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  String governorate;
  DateTime selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 3);

  List listItem = [
    'Al Sharqia',
    'Alexandria',
    'Aswan',
    'Asyut',
    'Behira',
    'Beni Suef',
    'Cairo',
    'Dakahlia',
    'Damietta',
    'Faiyum',
    'Gharbia',
    'Giza',
    'Ismalia'
        'Kafr el-Sheikh',
    'Luxor',
    'Matruh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sohag',
    'South Sinai',
    'Suez'
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    return StreamBuilder(
      stream: CloudFirestoreService.instance.documentStream(
          path: "/users/${auth.uid}",
          builder: (Map<String, dynamic> data, String documentID) => data),
      builder: (context, userdata) {
        if (userdata.hasError) {
          print(userdata.error.toString());
          return Text(
              'Something went wrong xxxxxxxxxxx, ${userdata.error.toString()}');
        }
        if (userdata.hasData) {
          TextEditingController cityController = TextEditingController(
              text: ("${userdata.data['adress']['city']}" != null
                  ? "${userdata.data['adress']['city']}"
                  : ""));
          TextEditingController bNumberController = TextEditingController(
              text: ("${userdata.data['adress']['building_number']}" != null
                  ? "${userdata.data['adress']['building_number']}"
                  : ""));
          TextEditingController fNumberController = TextEditingController(
              text: ("${userdata.data['adress']['floor_number']}" != null
                  ? "${userdata.data['adress']['floor_number']}"
                  : ""));
          TextEditingController aNumberController = TextEditingController(
              text: ("${userdata.data['adress']['apartment_number']}" != null
                  ? "${userdata.data['adress']['apartment_number']}"
                  : ""));
          TextEditingController streetController = TextEditingController(
              text: ("${userdata.data['adress']['street']}" != null
                  ? "${userdata.data['adress']['street']}"
                  : ""));

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Shipping and payment",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    "Shipping information",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextFormField("Apt Number",
                            aNumberController, widget.enabledEditing),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: buildTextFormField("floor Number",
                              fNumberController, widget.enabledEditing),
                          flex: 1),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: buildTextFormField("building Number",
                              bNumberController, widget.enabledEditing),
                          flex: 1),
                    ],
                  ),
                  buildTextFormField(
                      "Street", streetController, widget.enabledEditing),
                  buildTextFormField(
                      "City", cityController, widget.enabledEditing),
                  buildDropDownMenu(userdata.data['adress']['governorate'],
                      widget.enabledEditing),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.enabledEditing == false) {
                          widget.enabledEditing = true;
                          print(widget.enabledEditing);
                          setState(() {});
                        } else {
                          update(
                              context,
                              auth,
                              bNumberController,
                              cityController,
                              streetController,
                              aNumberController,
                              fNumberController);
                          widget.enabledEditing = false;
                          print(widget.enabledEditing);
                          setState(() {});
                        }
                      },
                      child: Text(
                          widget.enabledEditing == false
                              ? "Edit address"
                              : "Confirm editing",
                          style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: Colors.white,
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(child: monthlyCartWidgets(auth.uid)),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.enabledEditing == false
                          ? () async {
                              await CheckingOutServices().addNewOrder(
                                  productIDs: widget.productIDs,
                                  price: widget.orderPrice,
                                  uid: auth.uid,
                                  address: {
                                    "building_number": userdata.data['adress']['building_number'],
                                    "city": userdata.data['adress']['city'],
                                    "street": userdata.data['adress']['street'],
                                    "governorate": userdata.data['adress']['governorate'],
                                    "apartment_number": userdata.data['adress']['apartment_number'],
                                    "floor_number":userdata.data['adress']['floor_number']
                                  },
                                  selectedDate: selectedDate);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaymentScreen(),
                              ));
                              await MonthlyCartsBloc(uid: auth.uid)
                                  .setCheckedOut(widget.cartPath);
                            }
                          : null,
                      child: Text(
                        "Proceed to Checkout",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: Colors.orange,
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container monthlyCartWidgets(String uid) {
    if (widget.isMonthlyCart) {
      return Container(
          child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Delivery Date:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Text('${selectedDate.month} / ${selectedDate.day}')),
              SizedBox(height: 5),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day + 3),
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day + 3),
                          lastDate: DateTime(2101));
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                        await MonthlyCartsBloc(uid: uid)
                            .editCartDate(widget.cartPath, selectedDate);
                      }
                    },
                    child: Text(
                      "Change Date",
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: Colors.white,
                      padding: EdgeInsets.all(20),
                    )),
              ),
            ],
          ),
        ],
      ));
    }
  }

  Widget buildTextFormField(
      String labelText, TextEditingController cont, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        enabled: enabled,
        style: TextStyle(fontSize: 15.0, color: Colors.black),
        controller: cont,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          labelText: labelText,
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(
              color: Colors.black87,
            ),
          ),
          focusedBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(
                color: Colors.orange,
              )),
          disabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(
              color: Colors.grey[350],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropDownMenu(data, bool enabledEditing) {
    return IgnorePointer(
      ignoring: !enabledEditing,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: DropdownButtonFormField(
          style: TextStyle(fontSize: 13.0, color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            labelText: (data == null) ? "Governorate" : data,
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(
                color: enabledEditing ? Colors.black87 : Colors.grey[350],
              ),
            ),
            disabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(
                color: Colors.grey[350],
              ),
            ),
          ),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down,
              color: enabledEditing ? Colors.orange : Colors.grey),
          iconSize: 36,
          value: governorate,
          onChanged: (newValue) {
            setState(() {
              governorate = newValue;
            });
          },
          items: listItem.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem,
              child: Text(valueItem),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future update(
      BuildContext context,
      FirebaseAuthService auth,
      TextEditingController bNumberController,
      TextEditingController cityController,
      TextEditingController streetController,
      TextEditingController aNumberController,
      TextEditingController fNumberController) async {
    Map<String, dynamic> newAdress;
    newAdress = {
      "building_number": bNumberController.text,
      "city": cityController.text,
      "street": streetController.text,
      "governorate": governorate,
      "apartment_number": aNumberController.text,
      "floor_number": fNumberController.text
    };

    // Update adress.
    await CloudFirestoreService.instance.updateDocumentField(
        collectionPath: "users/",
        documentID: auth.user.uid,
        fieldName: 'adress',
        updatedValue: newAdress);
  }
}