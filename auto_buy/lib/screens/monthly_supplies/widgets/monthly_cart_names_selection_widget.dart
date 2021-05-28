import 'package:auto_buy/screens/monthly_supplies/monthly_carts_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartNameDropDownButton extends StatefulWidget {
  @override
  _CartNameDropDownButtonState createState() => _CartNameDropDownButtonState();
}

class _CartNameDropDownButtonState extends State<CartNameDropDownButton> {
  String selectedName;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MonthlyCartsScreenBloc>(context, listen: false);
    return StreamBuilder<List<String>>(
        stream: bloc.cartNamesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: new DropdownButton<String>(
                      hint: Text(
                        "Select Cart Name",
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: selectedName,
                      onChanged: (String name) {
                        setState(() {
                          selectedName = name;
                          bloc.changeSelectedCart(selectedName);
                        });
                      },
                      items: snapshot.data.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList()),
                ),
              ],
            );
          } else {
            return Container(
              color: Colors.red,
            );
          }
        });
  }
}
