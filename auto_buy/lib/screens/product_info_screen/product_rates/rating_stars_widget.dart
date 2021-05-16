import 'package:auto_buy/screens/product_info_screen/product_info_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingStars extends StatefulWidget {
  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  bool starPressed = false;
  int starPressedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStars(),
        SizedBox(
          height: 5,
        ),
        ElevatedButton(
          child: Text('Rate'),
          onPressed: () async {
            await _onClickStar(starPressedIndex);
          },
          style: ElevatedButton.styleFrom(
              elevation: 10,
              primary: Colors.lightGreen,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle: TextStyle(
                  fontSize: 0.045 * MediaQuery.of(context).size.width,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Row _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; i++)
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  //  print(i+1);
                  starPressed = true;
                  starPressedIndex = i; // TODO refactor this code
                });
              },
              child: Icon(
                (starPressed && i <= starPressedIndex)
                    ? Icons.star
                    : Icons.star_border_purple500_outlined,
                color: (starPressed && i <= starPressedIndex)
                    ? Colors.yellowAccent[700]
                    : Colors.grey[600],
                size: 40,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onClickStar(int i) async {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    await bloc.rateTheProductByNStars(i + 1);
  }
}
