import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static FirebaseStorageService instance = FirebaseStorageService._();

  Future<String> downloadURL(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    return downloadURL;
  }

  Future<void> uploadExample(String filepath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.absolute}/$filepath';

    await _uploadFile(filePath);
  }

  Future<void> _uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/file-to-upload.png')
          .putFile(file);
    } on firebase_storage.FirebaseException catch (e) {
      rethrow;
      // e.g, e.code == 'canceled'
    }
  }
}
