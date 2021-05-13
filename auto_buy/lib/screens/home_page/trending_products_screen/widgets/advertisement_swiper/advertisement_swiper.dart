import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/backend/home_page_products_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';

class AdvertisementSwiper extends StatefulWidget {
  @override
  _AdvertisementSwiperState createState() => _AdvertisementSwiperState();
}

class _AdvertisementSwiperState extends State<AdvertisementSwiper> {
  @override
  Widget build(BuildContext context) {
    final services =
        Provider.of<HomePageProductsServices>(context, listen: false);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final scale = isPortrait ? 0.4 : 0.7;
    final height = scale * MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: services.advertisementStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Advertisement>> snapshot) {
          try {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: height,
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<Advertisement> advertisements = snapshot.data;
              return FutureBuilder<List<String>>(
                future: getAdImagesURL(snapshot.data),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else {
                        final urls = snapshot.data;
                        return _buildContent(
                            context, advertisements, urls, height);
                      }
                  }
                },
              );
            } else {
              return Text("no data");
            }
          } on Exception catch (e) {
            throw e;
          }
        });
  }

  Padding _buildContent(
      BuildContext context,
      List<Advertisement> advertisementsList,
      List<String> urls,
      double height) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print(
                    "AD_MODEL_ON_TAP Search using : ${advertisementsList[index].searchQuery}");
                // TODO: Search using advertisementsList[index].searchQuery
              },
              child: Image.network(
                urls[index],
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

  Future<List<String>> getAdImagesURL(List<Advertisement> data) async {
    print("START LOADING");
    List<String> urls = [];
    final services =
        Provider.of<HomePageProductsServices>(context, listen: false);
    for (int i = 0; i < data.length; i++) {
      String url = await services.getAdvertisementImageURL(data[i].imagePath);
      urls.add(url);
      print("URL: $url");
    }

    return urls;
  }
}
