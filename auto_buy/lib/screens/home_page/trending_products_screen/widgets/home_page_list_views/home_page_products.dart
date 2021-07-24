import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/widgets/home_page_products_list.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list_type.dart';
import 'products_list_view_bloc.dart';

class HomePageProductsListView extends StatefulWidget {
  final ProductsListViewBloc bloc;

  const HomePageProductsListView({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context, ListType listType) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Provider<ProductsListViewBloc>(
      create: (_) => ProductsListViewBloc(type: listType, uid: auth.uid),
      child: Consumer<ProductsListViewBloc>(
        builder: (_, bloc, __) => HomePageProductsListView(bloc: bloc),
      ),
    );
  }

  @override
  _HomePageProductsListViewState createState() =>
      _HomePageProductsListViewState();
}

class _HomePageProductsListViewState extends State<HomePageProductsListView> {
  @override
  Widget build(BuildContext context) {
    final height = _calcHeight(context);
    return FutureBuilder<List<Product>>(
        future: widget.bloc.readProducts(),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              /*setState(() {

              });*/
              return Text(
                  'Something went wrong , check your internet connection');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: height, child: LoadingImage(height: 0.5 * height));
            }
            if (snapshot.hasData) {
              return HomePageProductsList(
                  products: snapshot.data);
            } else
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        });
  }

  double _calcHeight(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final scale = isPortrait ? 0.36 : 0.62;
    return scale * MediaQuery.of(context).size.height;
  }
}
