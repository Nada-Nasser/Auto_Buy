import 'package:auto_buy/screens/product_info_screen/product_info_screen_bloc.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingStars extends StatefulWidget {
  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return StreamBuilder<UserRatingStarsModel>(
        stream: bloc.ratingStarsModelStream,
        initialData: bloc.ratingStarsModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildContent(context, snapshot.data);
          } else
            return LoadingImage();
        });
  }

  Widget _buildContent(BuildContext context, UserRatingStarsModel data) {
    return Column(
      children: [
        _buildStars(data),
        SizedBox(
          height: 5,
        ),
        ElevatedButton(
          child: Text('Rate'),
          onPressed: () async {
            await _onClickRateButton(data.starPressedIndex);
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

  Row _buildStars(UserRatingStarsModel data) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; i++)
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: GestureDetector(
              onTap: () {
                bloc.starPressed(i);
              },
              child: Icon(
                (data.starPressed && i <= data.starPressedIndex)
                    ? Icons.star
                    : Icons.star_border_purple500_outlined,
                color: (data.starPressed && i <= data.starPressedIndex)
                    ? Colors.yellowAccent[700]
                    : Colors.grey[600],
                size: 40,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onClickRateButton(int i) async {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    await bloc.rateTheProductByNStars(i + 1);
  }
}
