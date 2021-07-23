import 'package:auto_buy/screens/optio/optio_screen.dart';
import 'package:auto_buy/screens/search_bar/search_bar.dart';
import 'package:flutter/material.dart';

Widget customSearchBar(BuildContext context) {
  return Container(
    padding: EdgeInsets.fromLTRB(50, 5, 0, 5),
    child: Row(
      children: [
        Flexible(
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
        ),
        IconButton(
            icon: Image.asset('assets/images/optioface.png'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => OptioScreen(),
                ),
              );
            }),
      ],
    ),
  );
}
