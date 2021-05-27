import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/services/categoryServices.dart';
import 'package:auto_buy/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'CategoryListView.dart';
import 'GetSubCategories.dart';
import 'SelectedCategoryNotifier.dart';

class GetCategories extends StatefulWidget {
  static int selectedIndx = 0;
  static List<category> categs = [];
  static List<String> sub_categories = [];
  Future<List<category>> _future;

  @override
  _GetCategoriesState createState() => _GetCategoriesState();
}

class _GetCategoriesState extends State<GetCategories> {
  @override
  void initState() {
    // TODO: implement initState
    widget._future = categoryServices().ReadCategoriesFromFirestore();
    super.initState();
  }

  changeSelectedIndx(int i) {
    GetCategories.selectedIndx = i;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectedCategoryNotifier(GetCategories.selectedIndx),
      child: FutureBuilder(
        future: widget._future,
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong , ${snapshot.error.toString()}');
            }
            if (snapshot.hasData) {
              GetCategories.categs = snapshot.data;
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
                                decoration: BoxDecoration(color: Colors.white),
                                child: getSubCategories(),
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
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        },
      ),
    );
  }
}
