import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class QuantityAndTotalPrice extends StatefulWidget {
  //final Product product;
  final double productPrice;
  final int productNumberInStock;

  const QuantityAndTotalPrice({
    Key key,
    this.productPrice,
    this.productNumberInStock,
  }) : super(key: key);

  @override
  _QuantityAndTotalPriceState createState() => _QuantityAndTotalPriceState();
}

class _QuantityAndTotalPriceState extends State<QuantityAndTotalPrice> {
  int quantity = 0;

  double get price => quantity * widget.productPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityWidget(context),
        _buildTotalPriceWidget(context),
      ],
    );
  }

  Widget _buildTotalPriceWidget(BuildContext context) {
    return Container(
      width: 0.50 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //decoration: _boxDecoration(Colors.black),
      child: Column(
        children: [
          Text(
            "Total Price : ",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 0.0446 * MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              "EGP ${price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 0.06 * MediaQuery.of(context).size.width,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityWidget(BuildContext context) {
    return Container(
      width: 0.40 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                if (quantity > 0)
                  quantity--;
                else
                  showInSnackBar("You cannot buy less than 0 item", context);
              });
            },
            child: Container(
              //  color: Colors.grey,
              child: Text(
                "-",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 0.12 * MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "$quantity",
            style: TextStyle(
              fontSize: 0.08 * MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                if (quantity < widget.productNumberInStock)
                  quantity++;
                else
                  showInSnackBar(
                      "You cannot buy more than ${widget.productNumberInStock} items",
                      context);
              });
            },
            child: Text(
              "+",
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 0.12 * MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
