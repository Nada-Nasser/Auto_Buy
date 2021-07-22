import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/categoryServices.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_category_listView.dart';
import '../subCategoryWidgets/sub_categories_screen.dart';
import '../SelectedCategoryNotifier.dart';
// import '../subCategoryWidgets/GetSubCategories.dart';
import 'main_category_listView.dart';

class mainCategoriesScreen extends StatefulWidget {
  static List<category> categs = [];
  static List<Product> AllProducts = [];

  final Future<List<category>> _Categoryfuture =
      categoryServices().ReadCategoriesFromFirestore();
  final Future<List<Product>> _Productfuture =
      ProductsBackendServices().readProductsFromFirestore();

  @override
  _mainCategoriesScreenState createState() => _mainCategoriesScreenState();
}

class _mainCategoriesScreenState extends State<mainCategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectedCategoryNotifier(0,0),
      child: FutureBuilder(
        future: Future.wait([widget._Categoryfuture , widget._Productfuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          try {
           // final myListener = context.select<SelectedCategoryNotifier,bool>((value) => value.isAllSelected);

            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong xxxxxxxxxxx, ${snapshot.error.toString()}');
            }
            if (snapshot.hasData) {
              mainCategoriesScreen.categs = snapshot.data[0];
              mainCategoriesScreen.AllProducts =snapshot.data[1];
              return //CategoryListView(categories : GetCategories.categs);
                  Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Scaffold(
                        appBar: customAppBar(context),
                        body: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Scaffold(
                                  body: mainCategoriesListView(
                                      categories: mainCategoriesScreen.categs),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                padding: EdgeInsets.fromLTRB(1, 5, 2, 0),
                                decoration: BoxDecoration(color: Colors.transparent),
                                child:SubCategoriesListView(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else
              return Center(child: CircularProgressIndicator());
          } on Exception catch (e) {
            throw e;
          }
        },
      ),
    );
  }
}


