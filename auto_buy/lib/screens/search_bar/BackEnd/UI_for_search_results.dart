import 'package:auto_buy/models/peoducts_list.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/widgets/home_page_products_list.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_tile.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPrettyListView extends StatelessWidget {
  final double height;
  final double width;
  final int numOfProdInGrid;
  final List<Product> productsList;

  ProductPrettyListView({
    Key key,
    this.height = 200.0,
    this.width = 200.0,
    this.numOfProdInGrid = 2,
    @required this.productsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: productsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numOfProdInGrid,
                childAspectRatio: height/width, //TODO this is not the correct format
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: ProductListTile(
                        height: height,
                        width: width,
                        product: productsList[index],
                        onTap: () {
                          //  Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => ProductInfoScreen.create(
                                context,
                                productsList[index],
                                productsList[index].picturePath,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}