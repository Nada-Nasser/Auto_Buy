import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen_bloc.dart';
import 'package:auto_buy/screens/product_info_screen/product_rates/rates_screen.dart';
import 'package:auto_buy/screens/product_info_screen/quantity_and_carts/adding_to_carts_buttons.dart';
import 'package:auto_buy/screens/product_info_screen/quantity_and_carts/quantity_and_total_price_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_description_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_image_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_name_and_price_widget.dart';
import 'package:auto_buy/screens/product_info_screen/widgets/product_number_in_stock_widget.dart';
import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/widgets/custom_search_bar.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          margin: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
        ),
        title: Text(""),
        elevation: 10,
      ),
      body: StreamBuilder<Product>(
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
      SizedBox(
        height: 5,
      ),
      ProductImage(
        productName: product.name,
        productURL: url,
      ),
      ProductNumberInStockWidget(numberInStock: product.numberInStock),
      QuantityAndTotalPrice(),
      AddingToCartsButtons(),
      ProductDescription(
        productBrand: product.brand,
        productCategory: product.categoryID,
        productDescription: product.description,
        productSize: product.size,
        productSizeUnit: product.sizeUnit,
        productSubCategory: product.subCategory,
      ),
      RatesSection(),
      SizedBox(height: 10),
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
