import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/home_page/trending_products_screen/widgets/home_page_list_views/peoducts_list.dart';
import 'package:auto_buy/services/api_paths.dart';
import 'package:auto_buy/services/firestore_service.dart';
import 'package:auto_buy/services/storage_service.dart';

class HomePageProductsServices {
  final _storageService = FirebaseStorageService.instance;
  final _firestoreService = CloudFirestoreService.instance;

  Future<String> getImageURL(String path) async =>
      await _storageService.downloadURL(path);

  Stream<List<Advertisement>> advertisementStream() =>
      _firestoreService.collectionStream(
        path: APIPath.advertisementsPath(),
        builder: (data, documentId) => Advertisement.fromMap(data, documentId),
      );

  Stream<List<ProductsList>> trendingProductsStream() =>
      _firestoreService.collectionStream(
        path: APIPath.trendingProductsPath(),
        builder: (data, documentId) => ProductsList.fromMap(data, documentId),
      );

  Stream<List<ProductsList>> eventProductsStream() =>
      _firestoreService.collectionStream(
        path: APIPath.productsPath(),
        builder: (data, documentId) => ProductsList.fromMap(data, documentId),
      );

  Future<Product> readProduct(String id) async {
    Product product = await _firestoreService.readOnceDocumentData(
      collectionPath: "products",
      documentId: id,
      builder: (data, documentID) => Product.fromMap(data, documentID),
    );

    String url = await getImageURL(product.picturePath);
    product.picturePath = url;
    return product;
  }

// TODO: add recommended for user products stream
}
