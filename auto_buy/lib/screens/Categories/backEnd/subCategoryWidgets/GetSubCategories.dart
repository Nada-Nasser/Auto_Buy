import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/Categories/backEnd/subCategoryWidgets/widgets/SeeAllProductsWidget.dart';
import 'package:auto_buy/screens/Categories/backEnd/subCategoryWidgets/widgets/getAllProducts.dart';
import 'package:auto_buy/screens/Categories/backEnd/subCategoryWidgets/widgets/productsInSubCategView.dart';
import '../MainCategoryWidgets/GetCategories.dart';
import 'package:auto_buy/screens/Categories/backEnd/SelectedCategoryNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class getSubCategories extends StatefulWidget {
  Map<String, List<Product>> FromSubCategToProducts =
      Map<String, List<Product>>();
  Map<String, List<Product>> FromCategToProducts = Map<String, List<Product>>();

  @override
  _getSubCategoriesState createState() => _getSubCategoriesState();
}

class _getSubCategoriesState extends State<getSubCategories> {
  @override
  void initState() {
    print("init of subCategories here");
    CreatMapChosenProductsFromSubCateg();
    CreatMapChosenProductsFromCateg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final myListener = context.watch<SelectedCategoryNotifier>();
    category categ = GetCategories.categs[myListener.selectedIndex];
    return myListener.isAllSelected != 0
        ? (myListener.isAllSelected == 1?
    getAllProducts(
        mainCategory: categ.name, products: widget.FromCategToProducts[categ.name] ??[]):
    getAllProducts(
        mainCategory: myListener.subCategory, products: widget.FromSubCategToProducts[myListener.subCategory] ??[]))
        : Container(
            child: Column(
              children: [
                seeAllProductsWidget(),
                Expanded( //for each suncategory we will create a view
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: GetCategories
                        .categs[myListener.selectedIndex].subcategory.length,
                    itemBuilder: (context, indx) {
                      String curSubCateg = GetCategories
                          .categs[myListener.selectedIndex].subcategory[indx];
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
                                          onTap: () {
                                            Provider.of<SelectedCategoryNotifier>(context, listen: false)
                                            .isALLSubCategSELECTED(2,curSubCateg);
                                          },
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
                            Container(
                              height: 330,
                              child: productsInSubCategView(ProductsInSubCateg: widget.FromSubCategToProducts[curSubCateg],
                                TotalitemCount: widget.FromSubCategToProducts[curSubCateg] == null ? 0
                                  : widget.FromSubCategToProducts[curSubCateg].length,)
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

  void CreatMapChosenProductsFromSubCateg() {
    for (Product P in GetCategories.AllProducts) {
      String subCat = P.subCategory;
      if (!widget.FromSubCategToProducts.containsKey(subCat)) {
        widget.FromSubCategToProducts[subCat] = [];
      }
      widget.FromSubCategToProducts[subCat].add(P);
    }
  }

  void CreatMapChosenProductsFromCateg() {
    for (Product P in GetCategories.AllProducts) {
      String Categ = P.categoryID;
      if (!widget.FromCategToProducts.containsKey(Categ)) {
        widget.FromCategToProducts[Categ] = [];
      }
      widget.FromCategToProducts[Categ].add(P);
    }
  }
}


