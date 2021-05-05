import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/advertisement_swiper.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_products_list_view.dart';
import 'package:flutter/material.dart';

import '../home_page_catigories.dart';

class HomePageProducts extends StatelessWidget {
  final List<Advertisement> adList = [
    Advertisement(
        id: "",
        imagePath: "assets/images/testing_ads/ad2.png",
        searchQuery: ""),
    Advertisement(
      id: "",
      imagePath: "assets/images/testing_ads/ad3.png",
      searchQuery: "",
    ),
    Advertisement(
        id: "",
        imagePath: "assets/images/testing_ads/ad4.png",
        searchQuery: ""),
    Advertisement(
        id: "",
        imagePath: "assets/images/testing_ads/ad5.png",
        searchQuery: ""),
  ];

  final List<Product> eventCollectionProductsList = [
    Product(
        id: "id",
        name: "Aldoha Egyptian Rice - 5 Kg",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/2.jpg",
        price: 74,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "Afia Plus Corn Oil – 1600ml",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/3.jpg",
        price: 62,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "Finish Classic Powder Dishwasher Detergent",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/1.jpg",
        price: 200,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
  ];

  final List<Product> topSellingProductsList = [
    Product(
        id: "id",
        name:
            "Lenovo V14 Laptop - Ryzen 3 3250U - 4GB RAM - 1 TB HDD - AMD Radeon GPU - 14 Inch FHD - Dos - Iron Grey",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/5.jpg",
        price: 5666,
        hasDiscount: true,
        priceBeforeDiscount: 7999,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "Fresh Stand Fan With Remote Control - 18 Black",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/6.jpg",
        price: 777,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
  ];

  final List<Product> recommendedForUserProductsList = [
    Product(
        id: "id",
        name:
            "Lenovo V14 Laptop - Ryzen 3 3250U - 4GB RAM - 1 TB HDD - AMD Radeon GPU - 14 Inch FHD - Dos - Iron Grey",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/5.jpg",
        price: 5666,
        hasDiscount: true,
        priceBeforeDiscount: 7999,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "Fresh Stand Fan With Remote Control - 18 Black",
        numberInStock: 0,
        picturePath: "assets/images/testing_ads/6.jpg",
        price: 777,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
    Product(
        id: "id",
        name: "product name",
        numberInStock: 0,
        picturePath: "assets/images/optioface.png",
        price: 200,
        categoryID: "categoryID"),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      homePageCatigories(context), // TODO : FARAH
      SizedBox(height: 10),
      buildSectionHeader(context, "Top Sales"),
      AdvertisementSwiper(advertisementsList: adList),
      buildDivider(),
      buildSectionHeader(context, "Most Trending"),
      HomePageProductsListView(productsList: topSellingProductsList),
      buildDivider(),
      buildSectionHeader(context, "Event Collection"),
      HomePageProductsListView(productsList: eventCollectionProductsList),
      buildDivider(),
      buildSectionHeader(context, "Recommended for you"),
      HomePageProductsListView(productsList: recommendedForUserProductsList),
      buildDivider(),
    ];

    return ListView.builder(
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index) {
        return content[index];
      },
    );
  }

  Divider buildDivider() {
    return Divider(
      height: 20,
      thickness: 2,
    );
  }

  Widget buildSectionHeader(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 0.0555 * MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }

}
