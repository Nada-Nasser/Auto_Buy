import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../products_list_view_bloc.dart';

class HomePageProductsList extends StatefulWidget {
  final List<String> ids;

  const HomePageProductsList({Key key, this.ids}) : super(key: key);

  @override
  _HomePageProductsListState createState() => _HomePageProductsListState();
}

class _HomePageProductsListState extends State<HomePageProductsList> {
  @override
  void initState() {
    print("START Fetching home page products");
    final bloc = Provider.of<ProductsListViewBloc>(context, listen: false);
    bloc.fetchProducts(widget.ids);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProductsListViewBloc>(context, listen: false);
    return StreamBuilder<List<Product>>(
        stream: bloc.productsStream,
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong , ${snapshot.error.toString()}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                child: LoadingImage(),
                height: _calcHeight(context),
              );
            }
            if (snapshot.hasData) {
              return ProductsListView(
                  height: _calcHeight(context), productsList: snapshot.data);
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
