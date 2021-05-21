import 'package:flutter/foundation.dart';

class Rate {
  final String id;
  final int nStars;

  Rate({@required this.nStars, @required this.id});

  factory Rate.fromMap(Map<String, dynamic> values, String id) {
    return Rate(
      id: id,
      nStars: values['n_stars'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'n_stars': this.nStars,
    };
  }
}
