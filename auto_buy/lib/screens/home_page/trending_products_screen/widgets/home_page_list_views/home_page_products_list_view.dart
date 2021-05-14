import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/peoducts_list.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/widgets/product_list_view.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list_type.dart';
import 'products_list_view_bloc.dart';

class HomePageProductsListView extends StatelessWidget {
  final ProductsListViewBloc bloc;

  const HomePageProductsListView({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context, ListType listType) {
    return Provider<ProductsListViewBloc>(
      create: (_) => ProductsListViewBloc(type: listType),
      child: Consumer<ProductsListViewBloc>(
        builder: (_, bloc, __) => HomePageProductsListView(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = calcHeight(context);
    return StreamBuilder<List<ProductsList>>(
        stream: bloc.modelStream(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductsList>> snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong , ${snapshot.error.toString()}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: height, child: LoadingImage(height: 0.5 * height));
            }
            if (snapshot.hasData) {
              List<ProductsList> products = snapshot.data;
              List<String> ids = products[0].ids;

              return _buildListFutureBuilder(context, ids);
            } else
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        });
  }

  Widget _buildListFutureBuilder(BuildContext context, List<String> ids) {
    final height = calcHeight(context);
    return FutureBuilder<List<Product>>(
      future: bloc.fetchProducts(ids),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
                height: height,
                child: LoadingImage(
                  height: 0.5 * height,
                ));
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              try {
                final products = snapshot.data;
                return buildContent(height, products);
              } on Exception catch (e) {
                throw e;
              }
            }
        }
      },
    );
  }

  Widget buildContent(double height, List<Product> productsList) {
    return ProductsListView(height: height, productsList: productsList);
  }

  double calcHeight(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final scale = isPortrait ? 0.36 : 0.62;
    return scale * MediaQuery.of(context).size.height;
  }
}
