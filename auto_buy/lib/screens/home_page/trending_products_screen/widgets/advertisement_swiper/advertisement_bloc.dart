import 'dart:async';

import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/backend/home_page_products_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertisementBloc {

  final HomePageProductsServices databaseServices = HomePageProductsServices();

  Stream<List<Advertisement>> get modelStream =>
      databaseServices.advertisementStream();

  Future<List<String>> getAdImagesURL(List<Advertisement> data) async {
    print("START LOADING");
    List<String> urls = [];

    for (int i = 0; i < data.length; i++) {
      String url = await databaseServices.getAdvertisementImageURL(
          data[i].imagePath);
      urls.add(url);
    }
    print("DONE LOADING");


    return urls;
  }


}


