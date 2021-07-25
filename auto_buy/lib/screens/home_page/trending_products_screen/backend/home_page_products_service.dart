import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/services/product_search_services.dart';

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

  Future<List<Product>> getProductsViaSearchQuery(String searchQuery) async {
    List<Product> p = await _getSearchResults(searchQuery);
    return p;
  }

  Future<List<Product>> _getSearchResults(String term) async {
    final ProductSearchServices searchService = ProductSearchServices();
    await searchService.toLowerCase();
    return searchService.search(term);
  }
}
