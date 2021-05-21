import 'package:auto_buy/screens/product_info_screen/backend/product_info_screen_bloc.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInSameCategoryWidget extends StatefulWidget {
  @override
  _ProductInSameCategoryWidgetState createState() =>
      _ProductInSameCategoryWidgetState();
}

class _ProductInSameCategoryWidgetState
    extends State<ProductInSameCategoryWidget> {
  Future myFuture;

  @override
  void initState() {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    myFuture = bloc.getProductSameCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Column(
            children: [
              _titleWidget(context),
              Container(width: 50, child: LoadingImage()),
            ],
          );
        } else
          return buildContent();
      },
    );
  }

  Column buildContent() {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return Column(
      children: [
        _titleWidget(context),
        ProductsListView(
          productsList: bloc.sameCategoryProducts,
        ),
      ],
    );
  }

  Widget _titleWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        "People also buy",
        style: TextStyle(
            color: Colors.grey[800],
            fontSize: 0.055 * MediaQuery.of(context).size.width,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
    );
  }
}
