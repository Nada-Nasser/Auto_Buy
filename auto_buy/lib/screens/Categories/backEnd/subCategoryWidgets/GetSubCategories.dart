import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/SearchBar/BackEnd/UI_for_search_results.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_tile.dart';
import '../MainCategoryWidgets/GetCategories.dart';
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
                onPressed: () {
                  getAllProducts();
                  print("called@");
                },
              ),
            ),
          ),
          Expanded(
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
                      Container(
                        height: 300,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount:
                              widget.FromSubCategToProducts[curSubCateg] == null
                                  ? 0
                                  : widget.FromSubCategToProducts[curSubCateg]
                                      .length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ProductListTile(
                                height: 100,
                                width: 100,
                                product: widget
                                    .FromSubCategToProducts[curSubCateg][index],
                                onTap: () {
                                  //  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          ProductInfoScreen.create(
                                        context,
                                        widget.FromSubCategToProducts[
                                            curSubCateg][index],
                                        widget
                                            .FromSubCategToProducts[curSubCateg]
                                                [index]
                                            .picturePath,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
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

class getAllProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("called");
    return Container(
      child: ProductPrettyListView(productsList: GetCategories.AllProducts),
    );
  }
}
