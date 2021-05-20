import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/models/peoducts_list.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';

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

  Future<Product> readProduct(String productID) async {
    Product product = await _firestoreService.readOnceDocumentData(
      collectionPath: APIPath.productsPath(),
      documentId: productID,
      builder: (data, documentID) => Product.fromMap(data, documentID),
    );

    String url = await getImageURL(product.picturePath);
    product.picturePath = url;
    return product;
  }

// TODO: add recommended for user products stream
}
