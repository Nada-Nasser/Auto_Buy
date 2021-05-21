import 'package:auto_buy/screens/home_page/trending_products_screen/backend/home_page_products_service.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/advertisement_swiper/advertisement_swiper.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/home_page_products.dart';
import 'package:auto_buy/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_page_catigories.dart';
import 'widgets/home_page_list_views/list_type.dart';

class HomePageProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      homePageCatigories(context),
      SizedBox(height: 10),
      buildSectionHeader(context, "Top Sales"),
      AdvertisementSwiper.create(context),
      buildDivider(),
      buildSectionHeader(context, "Most Trending"),
      HomePageProductsListView.create(
        context,
        ListType.MOST_TRENDING,
      ),
      buildDivider(),
      buildSectionHeader(context, "Event Collection"),
      HomePageProductsListView.create(
        context,
        ListType.EVENT_COLLECTION,
      ),
      buildDivider(),
      buildSectionHeader(context, "Recommended for you"),
      HomePageProductsListView.create(
        context,
        ListType.MOST_TRENDING,
      ),
      buildDivider(),
    ];

    return Provider<HomePageProductsServices>(
      create: (content) => HomePageProductsServices(),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (BuildContext context, int index) {
          return content[index];
        },
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
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 0.0655 * MediaQuery.of(context).size.width,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
