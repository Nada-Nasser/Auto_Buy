import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/Categories/backEnd/GetCategories.dart';
import 'package:auto_buy/screens/Categories/backEnd/SelectedCategoryNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class getSubCategories extends StatefulWidget {
  Map<String, List<Product>> FromSubCategToProducts =
      Map<String, List<Product>>();

  @override
  _getSubCategoriesState createState() => _getSubCategoriesState();
}

class _getSubCategoriesState extends State<getSubCategories> {
  @override
  void initState() {
    // TODO: implement initState
    print("init of subCategories here");
    CreatMapChosenProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("sub category called");
    final myListener = context.watch<SelectedCategoryNotifier>();
    return Container(
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                "ALL PRODUCTS",
                style: new TextStyle(
                  fontSize: 12.0,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                iconSize: 15,
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: GetCategories
                  .categs[myListener.selectedIndex].subcategory.length,
              itemBuilder: (context, indx) {
                return Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    GetCategories
                                        .categs[myListener.selectedIndex]
                                        .subcategory[indx],
                                    style: new TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      "SEE ALL",
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
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void CreatMapChosenProducts() {
    for (Product P in GetCategories.AllProducts) {
      String subCat = P.subCategory;
      if (!widget.FromSubCategToProducts.containsKey(subCat)) {
        widget.FromSubCategToProducts[subCat] = [];
      }
      widget.FromSubCategToProducts[subCat].add(P);
    }
  }
}
