import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class GoogleTranslate {

  final translator = GoogleTranslator();
  final _apiKey = 'AIzaSyBRdkpVjQlF0nhdk6nkrKLDiXWJusrB80o';

   Future<String> translate(String message) async {
    final response = await http.post(
     Uri.parse('https://translation.googleapis.com/language/translate/v2?target=en&key=AIzaSyBRdkpVjQlF0nhdk6nkrKLDiXWJusrB80o&q=$message'),
    );
    print('https://translation.googleapis.com/language/translate/v2?target=en&key=$_apiKey&q=$message');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final translations = body['data']['translations'] as List;
      final translation = translations.first;

      return HtmlUnescape().convert(translation['translatedText']);
    } else {
      throw Exception();
    }
  }

}