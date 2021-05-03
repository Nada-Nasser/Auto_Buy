import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class AdvertisementSwiper extends StatelessWidget {
  final List imgList;

  const AdvertisementSwiper({Key key, @required this.imgList})
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
            return new Image.asset(
              imgList[index],
              fit: BoxFit.fill,
            );
          },
          itemCount: imgList.length,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        ),
      ),
    );
  }
}
