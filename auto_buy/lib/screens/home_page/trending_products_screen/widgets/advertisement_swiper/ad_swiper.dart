import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/widgets/loading_image.dart';
import 'package:auto_buy/widgets/vertical_list_view/vertical_products_list_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

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
              onTap: () async {
                print(
                    "AD_MODEL_ON_TAP Search using : ${advertisementsList[index].searchQuery}");
                await _onClickAdvertisement(
                    context, advertisementsList[index].searchQuery);
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

  Future<void> _onClickAdvertisement(
      BuildContext context, String searchQuery) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => SearchResultsScreen(
            searchQuery: searchQuery, fun: _getSearchResults),
      ),
    );
  }

  Future<List<Product>> _getSearchResults(String term) async {
    final ProductSearchServices searchService = ProductSearchServices();
    await searchService.readAllProducts();
    return searchService.search(term);
  }
}

class SearchResultsScreen extends StatelessWidget {
  final Future<List<Product>> Function(String term) fun;
  final String searchQuery;

  const SearchResultsScreen({Key key, this.fun, this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            margin: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
          ),
          title: Text(""),
          elevation: 10,
        ),
        body: FutureBuilder<List<Product>>(
          future: fun(searchQuery),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return VerticalProductsListView(
                productsList: snapshot.data,
                onTap: (context, product) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ProductInfoScreen.create(
                        context,
                        product,
                        product.picturePath,
                      ),
                    ),
                  );
                },
              );
            }
          },
        )

        /*

      VerticalProductsListView(
        productsList: products,
        onTap: (context , product){
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => ProductInfoScreen.create(
                context,
                product,
                product.picturePath,
              ),
            ),
          );
        },
      ),*/
        );
  }
}
