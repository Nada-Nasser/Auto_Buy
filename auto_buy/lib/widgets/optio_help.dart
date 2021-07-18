import 'package:flutter/material.dart';

Future<void> optioHelpWidget(BuildContext context) async {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return await showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: AlertDialog(
          scrollable: true,
          title: new Text("Optio commands guide", textAlign: TextAlign.center),
          content: Container(
            child: Column(
              children: [
                optioHelpText('لاضافة مشتريات لعربة التسوق','قم باضافة <الكمية> <اسم المنتج> الى عربة التسوق'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('لمسح المشتريات من عربة التسوق', 'قم بمسح <اسم المنتج> من عربة التسوق'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('لفتح اي صفحة في التطبيق', ' افتح اسم الصفحة'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('للبحث عن منتجات', 'ابحث عن اسم المنتج'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('لاضافة صديق', 'قم باضافة صديق'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('لمسح صديق', 'قم بمسح صديق'),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget optioHelpText(String head, String body) {
  return Container(
    width: double.maxFinite,
    padding: EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          head,
          textAlign: TextAlign.right,
          locale: Locale('ar',''),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 20,
          ),
        ),
        Text(
          body,
          locale: Locale('ar',''),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        )
      ],
    ),
  );

}


