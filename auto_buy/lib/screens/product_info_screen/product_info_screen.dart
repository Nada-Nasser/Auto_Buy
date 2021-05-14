import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen_bloc.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/adding_to_carts_buttons.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_description_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_image_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_name_and_price_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/quantity_and_total_price_widget.dart';
import 'package:auto_buy/widgets/custom_search_bar.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfoScreen extends StatelessWidget {
  ProductInfoScreen({Key key, this.bloc, this.url}) : super(key: key);

  final ProductInfoScreenBloc bloc;
  final String url;

  static Widget create(BuildContext context, Product product, String url) {
    return Provider<ProductInfoScreenBloc>(
      create: (_) => ProductInfoScreenBloc(productID: product.id),
      child: Consumer<ProductInfoScreenBloc>(
        builder: (_, bloc, __) => ProductInfoScreen(bloc: bloc, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
            margin: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
            child: customSearchBar(context)),
        title: Text(""),
        elevation: 10,
      ),
      body: StreamBuilder<Product>(
          stream: bloc.modelStream,
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
                final product = snapshot.data;
                //     print('${product.toString()}');
                return _buildContent(context, product);
              } else
                return Text("no data");
            } on Exception catch (e) {
              throw e;
            }
          }),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    List<Widget> content = [
      ProductNameAndPrice(
        productName: product.name,
        productPrice: product.price,
      ),
      ProductImage(
        productName: product.name,
        productURL: url,
      ),
      QuantityAndTotalPrice(
        productPrice: product.price,
        productNumberInStock: product.numberInStock,
      ),
      AddingToCartsButtons(
        productID: product.id,
      ),
      ProductDescription(
        productBrand: product.brand,
        productCategory: product.categoryID,
        productDescription: product.description,
        productSize: product.size,
        productSizeUnit: product.sizeUnit,
        productSubCategory: product.subCategory,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (BuildContext context, int index) {
          return content[index];
        },
      ),
    );
  }
}
