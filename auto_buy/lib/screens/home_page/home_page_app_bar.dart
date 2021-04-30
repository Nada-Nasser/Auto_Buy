import 'package:auto_buy/screens/optio/optio_screen.dart';
import 'package:flutter/material.dart';

Widget homePageAppBar(BuildContext context){
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: customSearchBar(context),
      actions: [
      ],
    );

}

Widget customSearchBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(50, 5, 20, 5),
    child: TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(25.0),
          ),
        ),
        hintText: 'type something',
        fillColor: Colors.white,
        filled: true,
        //TODO: search button function
        suffixIcon: IconButton(icon: Icon(Icons.tag_faces), onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => OptioScreen(),
            ),
          );
        }),
      ),
    ),
  );
}
