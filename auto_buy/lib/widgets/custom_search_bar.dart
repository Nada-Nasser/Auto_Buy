import 'package:auto_buy/screens/home_page/SearchBar/searhBar.dart';
import 'package:auto_buy/screens/optio/optio_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

Widget customSearchBar(BuildContext context) {
  // TODO: FARAH
  return Padding(
    padding: EdgeInsets.fromLTRB(50, 5, 12, 5),
    child: TextFormField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'type something',
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
              icon: Icon(Icons.tag_faces),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => OptioScreen(),
                  ),
                );
              }),
        ),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return SearchBar();
                }),
          );
        }),
  );
}
