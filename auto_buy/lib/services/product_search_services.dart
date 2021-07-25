import 'package:auto_buy/models/Pair.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:string_similarity/string_similarity.dart';

class ProductSearchServices {

  List<Product> _allProducts = [];
  List<Pair<String,String>> _productNamesListAndID = [];
  final Map<String, Product> _fromIDToProduct = {};

  bool hasProducts() {
    return _allProducts.isNotEmpty;
  }

  List<Product> toLowerCase() {
    _allProducts = ProductsBackendServices.instance.allProducts;
    for (Product prod in _allProducts) {
      _fromIDToProduct[prod.id] = prod;
      _productNamesListAndID.add(Pair(prod.name.toLowerCase(),prod.id));
    }
    return _allProducts;
  }

  List<Product> search(String searchTerm) {
    List<String> similarStrings = searchReturnsNames(searchTerm);
    List<Product> products = [];
    if(similarStrings.isNotEmpty)
      products = _convertFromNameToProduct(similarStrings);

    return products;
  }

  List<String> searchReturnsNames(String searchTerm) {
    if(searchTerm == "")
      return [];
    Set<String> similarStrings =  new Set<String>();
    List<Pair<double,String>> pairs = [];

    searchTerm = searchTerm.replaceAll(new RegExp("(^(al[ -]*))|(^(el[ -]*))"),'');

    if(searchTerm == "")
      return [];

    for(Pair<String,String> s in _productNamesListAndID) {
      pairs.add(Pair(s.element1.similarityTo(searchTerm), s.element2));
    }
    pairs.sort((a,b) => b.element1.compareTo(a.element1));

    for(Pair<double,String> p in pairs ) {
      if (p.element1 > .5)
        similarStrings.add(p.element2);
      else break;
    }
    pairs = [];
    for(Pair<String,String> s in _productNamesListAndID){
      List<String> sentenceSplit = searchTerm.split(" ");
        for (String word in sentenceSplit) {
          List<String> prodWords = s.element1.split(" ");
          for(String w in prodWords){
            print("SIMILARITY OF $w  and $word = ${w.similarityTo(word)}");

            if(w.similarityTo(word) > .7)
              similarStrings.add(s.element2);
          }
          if(word != "" && s.element1.contains(word)) {
            similarStrings.add(s.element2);
          }
        }
    }

    return similarStrings.toList();
  }

  List<Product> _convertFromNameToProduct(List<String> productNames){
    List<Product> products = [];
    for(String s in productNames){
      products.add(_fromIDToProduct[s]);
    }
    return products;
  }
}
