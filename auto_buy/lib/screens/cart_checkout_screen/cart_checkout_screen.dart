import 'package:auto_buy/screens/monthly_supplies/monthly_carts_bloc.dart';
import 'package:auto_buy/services/checkingOutServices.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartCheckoutScreen extends StatefulWidget {
  CartCheckoutScreen({
    this.cartPath,
    @required this.productIDs,
    @required this.orderPrice,
    this.isMonthlyCart = false,
    this.productIdsAndQuantity,
    this.isGift=false,
    this.friendId=false,
    this.productIdsAndPrices,
  });

  // final List<Product> products;
  final String cartPath;
  final double orderPrice;
  final bool isMonthlyCart;
  final bool isGift;
  final List<String> productIDs;
  final Map<String,int> productIdsAndQuantity;
  final Map<String,double> productIdsAndPrices;
  final friendId;
  bool enabledEditing = false;

  @override
  _CartCheckoutScreenState createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  String governorate;
  DateTime selectedDeliveryDate =  DateTime.now().add(new Duration(days:3));

  List listItem = [
    'Al Sharqia', 'Alexandria', 'Aswan', 'Asyut', 'Behira', 'Beni Suef', 'Cairo', 'Dakahlia', 'Damietta', 'Faiyum', 'Gharbia',
    'Giza', 'Ismalia', 'Kafr el-Sheikh', 'Luxor', 'Matruh', 'Minya', 'Monufia', 'New Valley', 'North Sinai', 'Port Said',
    'Qalyubia', 'Qena', 'Red Sea', 'Sohag', 'South Sinai', 'Suez'
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    print(widget.productIdsAndQuantity);
    return StreamBuilder(
      stream: CloudFirestoreService.instance.documentStream(
          path: "/users/${widget.isGift == false ? auth.uid : widget.friendId}",
          builder: (Map<String, dynamic> data, String documentID) => data),
      builder: (context, userdata) {
        if (userdata.hasError) {
          print(userdata.error.toString());
          return Text(
              'Something went wrong xxxxxxxxxxx, ${userdata.error.toString()}');
        }
        if (userdata.hasData) {
          print("in checkout screen");
          print(widget.productIDs);
          print(widget.productIdsAndPrices);
          print(widget.productIdsAndQuantity);
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Shipping information",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if(widget.isGift==true)Image.asset("assets/images/optio_gift.png"),
                    if(widget.isGift==true)Text(
                      "You are Sending a Gift to ${userdata.data['name']}, the gift will be delivered to the address provided by him",
                      textAlign: TextAlign.center,
                    ),
                    widget.isGift==false?Row(
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
                    ):Container(),
                    widget.isGift==false?buildTextFormField(
                        "Street", streetController, widget.enabledEditing):Container(),
                    widget.isGift==false?buildTextFormField(
                        "City", cityController, widget.enabledEditing):Container(),
                    widget.isGift==false?buildDropDownMenu(userdata.data['adress']['governorate'],
                        widget.enabledEditing):Container(),
                    widget.isGift==false?SizedBox(
                      height: 20,
                    ):Container(),
                    widget.isGift==false?Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.enabledEditing == false) {
                            widget.enabledEditing = true;
                            print(widget.enabledEditing);
                            setState(() {});
                          } else {
                            if(cityController.text.isNotEmpty && bNumberController.text.isNotEmpty && fNumberController.text.isNotEmpty
                                && aNumberController.text.isNotEmpty && streetController.text.isNotEmpty)
                            {
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
                            }else {
                              showInSnackBar("please fill in all the fields", context);
                            }

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
                    ):Container(),
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
                          ///changed prouctIDs to productIdsAndQuantity
                          await CheckingOutServices().addNewOrder(
                              productIDs: widget.productIDs,
                              price: widget.orderPrice,
                              uid: auth.uid,
                              productIdAndQuantity: widget.productIdsAndQuantity,
                              productIdAndPrices: widget.productIdsAndPrices,
                              address: {
                                "building_number": userdata.data['adress']
                                ['building_number'],
                                "city": userdata.data['adress']['city'],
                                "street": userdata.data['adress']['street'],
                                "governorate": userdata.data['adress']
                                ['governorate'],
                                "apartment_number": userdata.data['adress']
                                ['apartment_number'],
                                "floor_number": userdata.data['adress']
                                ['floor_number']
                              },
                              selectedDate: selectedDeliveryDate);
                          if (widget.isMonthlyCart == false) {
                            await CheckingOutServices().removeItemsFromCart(
                                shoppingCartPath:
                                "/shopping_carts/${auth.uid}/shopping_cart_items",
                                productIdsAndQuantity: widget.productIdsAndQuantity
                            );

                          }
                          else{
                            await MonthlyCartsBloc(uid: auth.uid)
                                .setCheckedOut(widget.cartPath ,true);
                            await CheckingOutServices().removeItemsFromCart(
                                shoppingCartPath:"",
                                isShoppingCart: false,
                                productIdsAndQuantity: widget.productIdsAndQuantity
                            );
                          }
                          showInSnackBar("checkout done!", context);
                          Navigator.of(context).pop();
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
              SizedBox(
                height: 10,
              ),
              Text(
                  "Please note that your monthly cart items will be automatically "
                      "ordered every 27 days to be delivered on the 30th day",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  )
              ),
              SizedBox(
                height: 10,
              ),
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
                      child: Text('${selectedDeliveryDate.month} / ${selectedDeliveryDate.day}')),
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
                          if (picked != null && picked != selectedDeliveryDate) {
                            setState(() {
                              selectedDeliveryDate = picked;
                            });
                            await MonthlyCartsBloc(uid: uid)
                                .editCartDate(widget.cartPath, selectedDeliveryDate);
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

Widget makeSure(
    BuildContext context,
    ) {
  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Are you sure you want to checkout??"),
              actions: [
                ElevatedButton(
                    onPressed: () {}, child: Text("proceed to checkout")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("go back")),
              ],
            );
          }));
}
