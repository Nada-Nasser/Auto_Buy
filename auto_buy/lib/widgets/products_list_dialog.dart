import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/vertical_list_view/vertical_products_list_view.dart';
import 'package:flutter/material.dart';

Future<void> productsListDialog(
  BuildContext screenContext,
  Future<void> Function(BuildContext context, Product product) onClickDone,
  List<Product> products,
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
              child: VerticalProductsListView(
                productsList: products,
                isPriceHidden: true,
                smallPic: true,
                onTap: (context, product) {
                  onClickDone(screenContext, product);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        });
      });
}
