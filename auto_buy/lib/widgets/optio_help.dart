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
          title: new Text("Optio commands guide", textAlign: TextAlign.start),
          content: Container(
            child: Column(
              children: [
                optioHelpText('adding products to carts','add {quantity} {product-name} to [shopping cart/monthly cart]'),
                // optioHelpText('اضافة مشتريات لعربة التسوق','قم باضافة الكمية اسم المنتج الى عربة التسوق'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('deleting products from carts', 'delete {product-name} from [shopping cart/monthly cart]'),
                // optioHelpText('مسح المشتريات من عربة التسوق', 'قم بمسح اسم المنتج من عربة التسوق'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('to open pages','open [friends lists/shopping cart/monthly cart/expense tracker]'),
                // optioHelpText('لفتح اي صفحة في التطبيق', ' افتح اسم الصفحة'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('to search for products','search for {product-name}'),
                // optioHelpText('للبحث عن منتجات', 'ابحث عن اسم المنتج'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('to add friends','add friend'),
                // optioHelpText('لاضافة صديق', 'قم باضافة صديق'),
                SizedBox(
                  height: 15,
                ),
                optioHelpText('to delete friends','delete friend'),
                // optioHelpText('لمسح صديق', 'قم بمسح صديق'),
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
    // padding: EdgeInsets.all(5),
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(0),
    //   color: Colors.white,
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.black.withOpacity(0.5),
    //       blurRadius: 3,
    //       offset: Offset(0, 3),
    //     )
    //   ],
    // ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 20,
          ),
        ),
        Text(
          body,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        )
      ],
    ),
  );

}

Widget optioHeaderText(String text) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.orange,
        fontSize: 20,
      ),
    ),
  );
}

Widget optioBodyText(String text) {
  return Container(
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}
