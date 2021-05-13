import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/backend/home_page_products_service.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/list_type.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/peoducts_list.dart';
import 'package:auto_buy/services/api_paths.dart';

class ProductsListViewBloc {
  final HomePageProductsServices databaseServices = HomePageProductsServices();
  String firestorePath;
  final ListType type;

  ProductsListViewBloc({this.type});

  Stream<List<ProductsList>> modelStream() {
    if (type == ListType.MOST_TRENDING) {
      firestorePath = APIPath.trendingProductsPath();
      return databaseServices.trendingProductsStream();
    } else if (type == ListType.EVENT_COLLECTION) {
      firestorePath = APIPath.eventProductsPath();
      return databaseServices.eventProductsStream();
    } else {
      firestorePath = APIPath.eventProductsPath();
      return databaseServices.eventProductsStream();
    }
  }

  Future<List<Product>> fetchProducts(List<String> ids) async {
    List<Product> products = [];
    for (int i = 0; i < ids.length; i++) {
      final product = await databaseServices.readProduct(ids[i]);
      products.add(product);
    }
    return products;
  }
}
