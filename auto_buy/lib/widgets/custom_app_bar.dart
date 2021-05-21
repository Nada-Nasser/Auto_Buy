import 'package:auto_buy/screens/home_page/home_page_screen.dart';
import 'package:flutter/material.dart';

import 'custom_search_bar.dart';

Widget customAppBar(BuildContext context, {hasLeading = true}) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    flexibleSpace: SafeArea(child: customSearchBar(context)),
    leading: hasLeading
        ? IconButton(
            icon: Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => HomePage(),
                ),
              );
            },
          )
        : null,
    actions: [],
  );
}
