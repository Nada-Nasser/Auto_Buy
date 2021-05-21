import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_in_same_category_widget/product_in_same_category_widget.dart';
import 'package:auto_buy/screens/product_info_screen/product_rates/rates_screen.dart';
import 'package:auto_buy/screens/product_info_screen/quantity_and_carts/adding_to_carts_buttons.dart';
import 'package:auto_buy/screens/product_info_screen/quantity_and_carts/quantity_and_total_price_widget.dart';
import 'package:auto_buy/screens/product_info_screen/quantity_and_carts/wish_list_button.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_description_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_image_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_name_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_number_in_stock_widget.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backend/product_info_screen_bloc.dart';

class ProductInfoScreen extends StatelessWidget {
  ProductInfoScreen({Key key, this.bloc, this.url}) : super(key: key);

  final ProductInfoScreenBloc bloc;
  final String url;

  static Widget create(BuildContext context, Product product, String url) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Provider<ProductInfoScreenBloc>(
      create: (_) => ProductInfoScreenBloc(
        product: product,
        uid: auth.uid,
      ),
      child: Consumer<ProductInfoScreenBloc>(
        builder: (_, bloc, __) => ProductInfoScreen(bloc: bloc, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        flexibleSpace: Container(
          margin: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
        ),

// homepage-trendingView
        title: Text(""),
        elevation: 10,
      ),
      body: _buildStreamBuilder(),
    );
  }

  StreamBuilder<Product> _buildStreamBuilder() {
    return StreamBuilder<Product>(
        stream: bloc.productOnChangeStream,
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong , ${snapshot.error.toString()}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(child: LoadingImage());
            }
            if (snapshot.hasData) {
              print("Product updated");
              final product = snapshot.data;
              bloc.updateProduct(product);
              return _buildContent(context, product);
            } else
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        });
  }

  Widget _buildContent(BuildContext context, Product product) {
    List<Widget> content = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProductName(productName: product.name),
          WishListButton(),
        ],
      ),
      _buildContainer(
          context,
          Column(
            children: [
              ProductImage(
                productName: product.name,
                productURL: url,
              ),
              ProductNumberInStockWidget(numberInStock: product.numberInStock),
            ],
          )),
      _buildContainer(
          context,
          Column(
            children: [
              QuantityAndTotalPrice(),
              AddingToCartsButtons(),
            ],
          )),
      _buildContainer(
          context,
          ProductDescription(
            productBrand: product.brand,
            productCategory: product.categoryID,
            productDescription: product.description,
            productSize: product.size,
            productSizeUnit: product.sizeUnit,
            productSubCategory: product.subCategory,
          )),
      _buildContainer(context, RatesSection()),
      SizedBox(height: 10),
      _buildContainer(context, ProductInSameCategoryWidget()),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (BuildContext context, int index) {
          return content[index];
        },
      ),
    );
  }

  BoxDecoration _boxDecorationNoBorders() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 1.0,
        ),
      ],
    );
  }

  Widget _buildContainer(BuildContext context, Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: _boxDecorationNoBorders(),
      padding: EdgeInsets.fromLTRB(5, 15, 5, 20),
      child: child,
    );
  }
}
