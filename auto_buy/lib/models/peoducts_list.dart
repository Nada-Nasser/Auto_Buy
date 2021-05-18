class ProductsList {
  final List<String> ids;

  ProductsList({this.ids});

  factory ProductsList.fromMap(Map<dynamic, dynamic> value, String id) {
    return ProductsList(
      ids: List.from(value['ids']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ids': this.ids,
    };
  }
}
