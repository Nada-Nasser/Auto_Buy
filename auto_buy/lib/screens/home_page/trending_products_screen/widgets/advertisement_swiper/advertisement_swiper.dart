import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ad_swiper.dart';
import 'advertisement_bloc.dart';

class AdvertisementSwiper extends StatelessWidget {

  final AdvertisementBloc bloc;

  const AdvertisementSwiper({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    return Provider<AdvertisementBloc>(
      create: (_) => AdvertisementBloc(),
      child: Consumer<AdvertisementBloc>(
        builder: (_, bloc, __) => AdvertisementSwiper(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = calcSwiperHeight(context);
    return StreamBuilder<List<Advertisement>>(
        stream: bloc.modelStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<Advertisement>> snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: height, child: LoadingImage(height: 0.5 * height));
            }
            if (snapshot.hasData) {
              List<Advertisement> advertisements = snapshot.data;
              return buildAdvertisementsFutureBuilder(
                  context, snapshot, advertisements);
            } else
              return Text("no data");
          } on Exception catch (e) {
            throw e;
          }
        });
  }

  FutureBuilder<List<String>> buildAdvertisementsFutureBuilder(
      BuildContext context,
      AsyncSnapshot<List<Advertisement>> snapshot,
      List<Advertisement> advertisements,) {
    double height = calcSwiperHeight(context);
    return FutureBuilder<List<String>>(
      future: bloc.getAdImagesURL(snapshot.data),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
                height: height, child: LoadingImage(height: 0.5 * height,));
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              try {
                final urls = snapshot.data;
                return ImageSwiper(
                  advertisementsList: advertisements,
                  height: height,
                  urls: urls,
                );
              } on Exception catch (e) {
                throw e;
              }
            }
        }
      },
    );
  }

  double calcSwiperHeight(BuildContext context) {
    bool isPortrait =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    final scale = isPortrait ? 0.4 : 0.7;
    return scale * MediaQuery
        .of(context)
        .size
        .height;
  }
}
