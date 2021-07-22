import 'package:auto_buy/models/Category.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';

class CategoryServices{
  final _firestoreService = CloudFirestoreService.instance;

  Future<List<category>> ReadCategoriesFromFirestore() async {
    List<category> categories = await _firestoreService.getCollectionData(
      collectionPath: APIPath.Categories(),
      builder: (value, id) => category.fromMap(value, id),
    );
    print("got categories");
    return categories;
  }
}
