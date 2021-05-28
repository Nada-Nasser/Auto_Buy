import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/SearchBar/BackEnd/UI_for_search_results.dart';
import 'package:auto_buy/services/categoryServices.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CategoryListView.dart';
import '../subCategoryWidgets/GetSubCategories.dart';
import '../SelectedCategoryNotifier.dart';

class GetCategories extends StatefulWidget {
  static int selectedIndx = 0;
  static List<category> categs = [];
  static List<String> sub_categories = [];
  static List<Product> AllProducts = [];

  final Future<List<category>> _Categoryfuture = categoryServices().ReadCategoriesFromFirestore();
  final Future<List<Product>> _Productfuture = ProductsBackendServices().ReadProductsFromFirestore();

  @override
  _GetCategoriesState createState() => _GetCategoriesState();
}

class _GetCategoriesState extends State<GetCategories> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectedCategoryNotifier(0,false),
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
              GetCategories.categs = snapshot.data[0];
              GetCategories.AllProducts =snapshot.data[1];
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
                                  body: CategoryListView(
                                      categories: GetCategories.categs),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                padding: EdgeInsets.fromLTRB(1, 5, 2, 0),
                                decoration: BoxDecoration(color: Colors.transparent),
                                child:getSubCategories(),
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


