import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/Categories/backEnd/subCategoryWidgets/widgets/all_products_screen.dart';
import 'package:auto_buy/screens/Categories/backEnd/subCategoryWidgets/widgets/products_in_subcategory_View.dart';
import '../MainCategoryWidgets/main_categories_screen.dart';
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
    category categ = mainCategScreen.categs[myListener.selectedIndex];
    return myListener.isAllSelected != 0
        ? (myListener.isAllSelected == 1?
    AllProductsView(
        mainCategory: categ.name, products: widget.FromCategToProducts[categ.name] ??[]):
    AllProductsView(
        mainCategory: myListener.subCategory, products: widget.FromSubCategToProducts[myListener.subCategory] ??[]))
        : Container(
            child: Column(
              children: [
                seeAllProductsWidget(),
                Expanded( //for each suncategory we will create a view
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: mainCategScreen
                        .categs[myListener.selectedIndex].subcategory.length,
                    itemBuilder: (context, indx) {
                      String curSubCateg = mainCategScreen
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
                                          mainCategScreen
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
    for (Product P in mainCategScreen.AllProducts) {
      String subCat = P.subCategory;
      if (!widget.FromSubCategToProducts.containsKey(subCat)) {
        widget.FromSubCategToProducts[subCat] = [];
      }
      widget.FromSubCategToProducts[subCat].add(P);
    }
  }

  void CreatMapChosenProductsFromCateg() {
    for (Product P in mainCategScreen.AllProducts) {
      String Categ = P.categoryID;
      if (!widget.FromCategToProducts.containsKey(Categ)) {
        widget.FromCategToProducts[Categ] = [];
      }
      widget.FromCategToProducts[Categ].add(P);
    }
  }
}



class seeAllProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
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
            onPressed: () {
              Provider.of<SelectedCategoryNotifier>(context, listen: false)
                  .isALLSELECTED(1);
            }),
      ),
    );
  }
}