import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CloudFirestoreService {
  CloudFirestoreService._();

  static CloudFirestoreService instance = CloudFirestoreService._();

  Future<List<T>> getCollectionData<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final result = query.get().then((value) => value.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList());

    return result;
  }

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

  Future<T> readOnceDocumentData<T>({
    @required String path,
    @required documentId,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) async {
    final ref = FirebaseFirestore.instance.collection(path);
    DocumentSnapshot snapshot = await ref.doc(documentId).get();
    return builder(snapshot.data(), documentId);
  }

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

  Future<void> setDocument({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteDocument({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

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

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
