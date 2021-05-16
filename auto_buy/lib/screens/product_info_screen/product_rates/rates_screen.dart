import 'package:auto_buy/screens/product_info_screen/product_rates/rating_stars_widget.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:flutter/material.dart';

import 'customer_rates_widget.dart';

class RatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: Column(
        children: [
          _title(context, "Rate this product"),
          RatingStars(),
          SizedBox(
            height: 20,
          ),
          _title(context, "Costumer Rates"),
          SizedBox(
            height: 7,
          ),
          CustomerRatesSection(),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        text,
        //"Costumer Rates",
        style: TextStyle(
            color: Colors.grey[800],
            fontSize: 0.055 * MediaQuery.of(context).size.width,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
    );
  }
}
