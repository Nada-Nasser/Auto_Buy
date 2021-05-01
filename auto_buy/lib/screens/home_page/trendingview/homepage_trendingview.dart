import 'package:auto_buy/screens/home_page/home_page_catigories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class HomePageProducts extends StatelessWidget {
  final List imgList = [
    "assets/images/testing_ads/ad1.png",
    "assets/images/testing_ads/ad2.png",
    "assets/images/testing_ads/ad3.png",
    "assets/images/testing_ads/ad4.png",
    "assets/images/testing_ads/ad5.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            buildSectionHeader(context, "Top Sales"),
            buildTopSalesAdSizedBox(context),
            buildDivider(),
            buildSectionHeader(context, "Most Trending"),
            homePageCatigories(context),
            buildSectionHeader(context, "Most Trending"),
            homePageCatigories(context),
          ],
        ),
      ),
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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

  Widget buildTopSalesAdSizedBox(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 0.35 * MediaQuery.of(context).size.height,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.asset(
            imgList[index],
            fit: BoxFit.fill,
          );
        },
        itemCount: 5,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
}
