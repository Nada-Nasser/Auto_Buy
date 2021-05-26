import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/services/categoryServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'CategoryListView.dart';

class GetCategories extends StatefulWidget {

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._future,
      builder: (context, snapshot)
        {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong , ${snapshot.error.toString()}');
            }
            if (snapshot.hasData) {
              GetCategories.categs = snapshot.data;
              return CategoryListView(categories : GetCategories.categs);
            } else
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        },
    );
  }
}
