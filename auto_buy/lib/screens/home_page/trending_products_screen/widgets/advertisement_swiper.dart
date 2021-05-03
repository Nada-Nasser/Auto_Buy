import 'package:auto_buy/models/advertisement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class AdvertisementSwiper extends StatelessWidget {
  final List<Advertisement> advertisementsList;

  const AdvertisementSwiper({Key key, @required this.advertisementsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final scale = isPortrait ? 0.4 : 0.7;
    final height = scale * MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height,
        //height: 200,
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("AD_MODEL_ON_TAP");
                // TODO: Search using advertisementsList[index].searchQuery
              },
              child: new Image.asset(
                advertisementsList[index].imagePath,
                fit: BoxFit.fill,
              ),
            );
          },
          itemCount: advertisementsList.length,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        ),
      ),
    );
  }
}
