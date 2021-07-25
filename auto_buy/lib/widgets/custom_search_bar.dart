import 'package:auto_buy/screens/optio/optio_screen.dart';
import 'package:auto_buy/screens/search_bar/search_bar.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:flutter/material.dart';

Widget customSearchBar(BuildContext context) {
  return Container(
    padding: EdgeInsets.fromLTRB(50, 5, 0, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) =>
                        SearchBar(),
                  ),
                );
              }),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
            //icon: Icon(Icons.face_outlined),
            icon: Image.asset('assets/images/optioface.png'),
            onPressed: () async {
              final ProductSearchServices searchService =
                  ProductSearchServices();
              searchService.toLowerCase();

              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>
                      OptioScreen(searchService: searchService),
                ),
              );
            }),
      ],
    ),
  );
}
