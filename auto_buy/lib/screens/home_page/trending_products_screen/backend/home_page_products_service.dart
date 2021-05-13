import 'package:auto_buy/models/advertisement_model.dart';
import 'package:auto_buy/services/api_paths.dart';
import 'package:auto_buy/services/firestore_service.dart';
import 'package:auto_buy/services/storage_service.dart';

class HomePageProductsServices {
  final _storageService = FirebaseStorageService.instance;
  final _firestoreService = CloudFirestoreService.instance;

  Future<String> getAdvertisementImageURL(String path) async =>
      await _storageService.downloadURL(path);

  Stream<List<Advertisement>> advertisementStream() =>
      _firestoreService.collectionStream(
        path: APIPath.advertisementsPath(),
        builder: (data, documentId) => Advertisement.fromMap(data, documentId),
      );
}
