import 'dart:async';

import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/backend/home_page_products_service.dart';

class AdvertisementBloc {
  final HomePageProductsServices _databaseServices = HomePageProductsServices();

  Stream<List<Advertisement>> get modelStream =>
      _databaseServices.advertisementStream();
}
