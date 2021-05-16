import 'package:auto_buy/screens/product_info_screen/product_info_screen_bloc.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerRatesSection extends StatefulWidget {
  @override
  _CustomerRatesSectionState createState() => _CustomerRatesSectionState();
}

class _CustomerRatesSectionState extends State<CustomerRatesSection> {
  @override
  void initState() {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    bloc.fetchProductCustomerRates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProductInfoScreenBloc>(context, listen: false);
    return StreamBuilder<List<int>>(
        stream: bloc.ratesStream,
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(
                  'Something went wrong , ${snapshot.error.toString()}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(child: LoadingImage());
            }
            if (snapshot.hasData) {
              return _buildContent(snapshot.data);
            } else
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        });
  }

  Container _buildContent(List<int> rates) {
    return Container(
      child: Column(
        children: [
          for (int i = 5; i > 0; i--)
            Row(
              children: [
                for (int j = 1; j <= 5; j++)
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Icon(
                      (j <= i)
                          ? Icons.star
                          : Icons.star_border_purple500_outlined,
                      color: (j <= i)
                          ? Colors.yellowAccent[700]
                          : Colors.grey[600],
                      size: 30,
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
                Text("${rates[i]} rate(s)")
              ],
            ),
        ],
      ),
    );
  }
}
