import 'package:auto_buy/models/product_model.dart';

import 'backend/product_info_screen_Services.dart';

class ProductInfoScreenBloc {
  ProductInfoScreenServices _services = ProductInfoScreenServices();
  final String productID;

  ProductInfoScreenBloc({this.productID});

  Stream<Product> get modelStream => _services.getProductStream(productID);
}
