import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/vertical_list_view/vertical_products_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../SelectedCategoryNotifier.dart';

class getAllProducts extends StatefulWidget {
  String mainCategory;
  List<Product> products = [];

  getAllProducts({@required this.mainCategory, @required this.products}) {
    if (products == null) products = [];
  }

  @override
  _getAllProductsState createState() => _getAllProductsState();
}

class _getAllProductsState extends State<getAllProducts> {
  @override
  Widget build(BuildContext context) {
    print("called");
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.mainCategory,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<SelectedCategoryNotifier>(context,
                          listen: false)
                          .isALLSELECTED(0);
                    },
                    child: Text(
                      "Back",
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: VerticalProductsListView(
                productsList:widget.products,
                listHeight: 80,
              )),
        ],
      ),
    );
  }
}