import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/cart_checkout_screen/cart_checkout_screen.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FriendWishList extends StatefulWidget {
  String friendId;
  String name;
  int checkListLength;
  List<bool> checkedOrNot;
  List<String> itemIds = [];
  Map<String,int> productIdsAndQuantity={};
  Map<String,double> productIdsAndPrices ={};
  FriendWishList({this.friendId,this.name,this.checkListLength}){
    checkedOrNot = List.filled(checkListLength, false);
  }
  @override
  _FriendWishListState createState() => _FriendWishListState();
}

class _FriendWishListState extends State<FriendWishList> {
  double totalPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifting"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed:()=> Navigator.of(context).pop()),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${widget.name}'s wishList",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Your cost is ${totalPrice.toStringAsFixed(2)}\$"
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: CloudFirestoreService.instance.getCollectionData(collectionPath: "wish_lists/${widget.friendId}/wish_list_products/",
                    builder: (Map<String, dynamic> data, String documentId) {
                      return documentId;
                    }),
                builder: (context, alldata) {
                  if(alldata.hasData){
                    return GridView.builder(
                      itemCount: alldata.data.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                        MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.5),
                      ),
                      itemBuilder: (context, index) {
                        ///this feature builder goes through each item in the user wishlist
                        return FutureBuilder(
                            future: CloudFirestoreService.instance
                                .readOnceDocumentData(
                                collectionPath: "/products/",
                                documentId:
                                "${alldata.data[index]}",
                                builder: (data, documentId) {
                                  Map<String,dynamic> output={"data":data,"id":documentId};
                                  return output;
                                }),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  height: 200,
                                  width: 40,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Checkbox(
                                              value: widget.checkedOrNot[index],
                                              onChanged: (bool value) async{
                                                  widget.checkedOrNot[index]=value;
                                                  if(!widget.itemIds.contains(alldata.data[index]))
                                                  {
                                                    widget.itemIds.add(alldata.data[index]);
                                                  }else{
                                                    widget.itemIds.remove(alldata.data[index]);
                                                  }
                                                  totalPrice = await calculatePriceAndQuantity();
                                                  setState(() {});
                                              }
                                            ),
                                        ],
                                      ),
                                      FutureBuilder(
                                          future: FirebaseStorageService
                                              .instance
                                              .downloadURL(snapshot
                                              .data['data']['pic_path']),
                                          builder: (context, image) {
                                            Product product = Product.fromMap(snapshot.data['data'], snapshot.data['id']);
                                            if (image.hasData) {
                                              return GestureDetector(
                                                onTap: (){
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      fullscreenDialog: true,
                                                      builder: (context) => ProductInfoScreen.create(
                                                        context,
                                                        product,
                                                        image.data,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: image.data,
                                                  placeholder:
                                                      (context, url) =>
                                                      LoadingImage(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                      Icon(Icons.error),
                                                  width: MediaQuery.of(context).size.width,
                                                ),
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                      Text(
                                        snapshot.data['data']['name'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.black.withOpacity(0.5),
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            });
                      },
                    );
                  }else{
                   return CircularProgressIndicator();
                  }
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                padding: EdgeInsets.all(20),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () async{
                if(widget.itemIds.length == 0){
                  showInSnackBar("Please choose a gift", context);
                }
                else{
                  totalPrice = await calculatePriceAndQuantity();
                  print("in wishlist");
                  print(widget.itemIds);
                  print(widget.productIdsAndPrices);
                  print(widget.productIdsAndQuantity);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CartCheckoutScreen(
                        orderPrice: totalPrice,
                        productIDs: widget.itemIds,
                        productIdsAndPrices: widget.productIdsAndPrices,
                        productIdsAndQuantity: widget.productIdsAndQuantity,
                        isMonthlyCart: false,
                        isGift: true,
                        friendId: widget.friendId,
                  )));
                }
              },
              child: Text(
                "Checkout Gift",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }


  Future<double> calculatePriceAndQuantity() async{
    double total = 0.0;
    Map<String, int> productIdsAndQuantity ={};
    Map<String, double> productIdsAndPrices = {};
    for(int i = 0 ; i < widget.itemIds.length ; i++)
    {
        dynamic productMap = await CloudFirestoreService.instance.readOnceDocumentData(collectionPath: "/products",
            documentId: widget.itemIds[i].toString(), builder: (Map<String, dynamic> data, String documentId)=>data);
        Product product = Product.fromMap(productMap, widget.itemIds[i]);
        if(product.hasDiscount==false)
            total += product.price;
        else
            total +=product.priceAfterDiscount;

        productIdsAndQuantity.update(widget.itemIds[i].toString(), (existingValue) => 1,
          ifAbsent: () => 1,);
        productIdsAndPrices.update(product.id, (existingValue) => product.hasDiscount?product.priceAfterDiscount:product.price,
          ifAbsent: () => product.hasDiscount?product.priceAfterDiscount:product.price);
    }
    widget.productIdsAndPrices = productIdsAndPrices;
    widget.productIdsAndQuantity = productIdsAndQuantity;
    return total;
  }
}


