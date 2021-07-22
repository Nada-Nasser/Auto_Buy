import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  FirebaseStorageService._();

  static FirebaseStorageService instance = FirebaseStorageService._();

  Future<String> downloadURL(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    return downloadURL;
  }
}
