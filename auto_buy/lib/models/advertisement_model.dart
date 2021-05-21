import 'package:flutter/foundation.dart';

class Advertisement {
  final String id;
  final String imagePath;
  final String searchQuery;

  Advertisement(
      {@required this.id,
      @required this.imagePath,
      @required this.searchQuery});

  factory Advertisement.fromMap(Map<dynamic, dynamic> value, String id) {
    return Advertisement(
      id: id,
      imagePath: value['image_ref'],
      searchQuery: value['search_query'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'image_ref': this.imagePath,
      'search_query': this.searchQuery,
    };
  }
}
