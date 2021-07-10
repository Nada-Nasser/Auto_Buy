import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CloudFirestoreService {
  CloudFirestoreService._();

  static CloudFirestoreService instance = CloudFirestoreService._();

  /// This function Read all documents in a collection and return it in a list
  /// The function uses [collectionPath] to reach the collection in firestore
  /// and uses [builder] to convert the map fetched from the firestore to the desired dataType [T]
  Future<List<T>> getCollectionData<T>({
    @required String collectionPath,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query) queryBuilder,
  }) async {
    Query query = FirebaseFirestore.instance.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final result = query.get().then((value) => value.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList());

    return result;
  }

  /// This function update a specific field value in a document in firestore
  /// it uses [collectionPath] to reach the collection that contains the document
  /// , [documentID] to reach the needed document only,
  /// [fieldName] which is the name of the field ew need to change its value
  /// and the [updatedValue] that contain the new value we want to write in firestore.
  Future<void> updateDocumentField(
      {@required String collectionPath,
      @required String documentID,
      @required String fieldName,
      @required dynamic updatedValue}) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(documentID)
          .update({'$fieldName': updatedValue});
      print(
          "$collectionPath/$documentID : $fieldName UPDATED with $updatedValue");
    } on Exception catch (e) {
      throw e;
    }
  }

  /// This function Read only one document in a collection and return it in a object with data type [T}.
  /// The function uses [collectionPath] to reach the collection in firestore
  /// , [documentId] to reach the needed document only,
  /// and uses [builder] to convert the map fetched from the firestore to the desired dataType [T]
  Future<T>   readOnceDocumentData<T>({
    @required String collectionPath,
    @required documentId,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) async {
    final ref = FirebaseFirestore.instance.collection(collectionPath);
    DocumentSnapshot snapshot = await ref.doc(documentId).get();
    return builder(snapshot.data(), documentId);
  }

  /// This function used to checks if a specific document exists in firestore or not
  /// it uses [docPath] to reach the needed document
  /// and returns [True] if it exists of [False] if not.
  Future<bool> checkExist({@required String docPath}) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc(docPath).get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  /// This function used to write new document in firestore
  /// it uses [documentPath] to reach the needed document,
  /// and [data] Map contains the document fields
  Future<String> setDocument({
    @required String documentPath,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(documentPath);
    print('$documentPath: $data');
    await reference.set(data);
    return reference.id;
  }


  Future<String> addDocument({
    @required String documentPath,
    @required Map<String, dynamic> data,
  }) async {
    final reference = await FirebaseFirestore.instance.collection(documentPath).add(data);
    print('$documentPath: $data');
    return reference.id;
  }
  /// This function used to delete document from firestore
  /// it uses [documentPath] to reach the needed document,
  Future<void>  deleteDocument({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Future<dynamic> readFieldValueFromDocument(
      {@required String collectionPath,
      @required String documentID,
      @required fieldName}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(documentID)
        .get();

    return snapshot.data()[fieldName];
  }

  /// This function used to delete collection from firestore
  /// it uses [documentPath] to reach the needed collection and loops to delete all the docs in collection,
  Future<void>  deleteCollection({@required String path}) async {
   await FirebaseFirestore.instance.collection(path).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      };
    });
  }
  /// This function returns a [Stream] on a collection in firestore
  /// that can be used to listen any event occur in this collection.
  /// it uses [path] to reach the collection in firestore
  /// , [builder] that convert any document in this collection into an object of type [T]
  /// , [queryBuilder] can be used to filter the received snapshots
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  /// This function returns a [Stream] on a specific document in firestore
  /// that can be used to listen any event occur in this document.
  /// it uses [path] to reach the document in firestore
  /// [builder] that convert that document fields into an object of type [T]
  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
