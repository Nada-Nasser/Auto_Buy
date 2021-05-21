import 'package:auto_buy/models/advertisement_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:auto_buy/widgets/loading_image.dart';

class ImageSwiper extends StatelessWidget {
  final List<Advertisement> advertisementsList;
  final List<String> urls;
  final double height;

  const ImageSwiper({Key key, this.advertisementsList, this.urls, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: height,
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print(
                    "AD_MODEL_ON_TAP Search using : ${advertisementsList[index]
                        .searchQuery}");
                // TODO: Search using advertisementsList[index].searchQuery
                //Navigator.pop(context); // pop home page screen ??
              },
              child: CachedNetworkImage(
                imageUrl: urls[index],
                placeholder: (context, url) => LoadingImage(),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
