import 'package:auto_buy/models/Pair.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:string_similarity/string_similarity.dart';

class ProductSearchServices {

  List<Product> _allProducts = [];
  List<String> _productNamesList = [];
  final Map<String, Product> _fromNameToProduct = {};

  bool hasProducts() {
    return _allProducts.isNotEmpty;
  }

  List<Product> toLowerCase() {
    _allProducts = ProductsBackendServices.instance.allProducts;
    for (Product prod in _allProducts) {
      _fromNameToProduct[prod.name.toLowerCase()] = prod;
      _productNamesList.add(prod.name.toLowerCase());
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

    for(String s in _productNamesList){
      pairs.add(Pair(s.similarityTo(searchTerm) , s));

      List<String> sentenceSplit = searchTerm.split(" ");
        for (String word in sentenceSplit) {
          if(word != "" && s.contains(word)) {
            similarStrings.add(s);
          }
          List<String> prodwords = s.split(" ");
          for(String w in prodwords){
            print("SIMILARITY OF $w  and $word = ${w.similarityTo(word)}");

            if(w.similarityTo(word) > .7)
              similarStrings.add(s);
          }
        }

    }
    pairs.sort((a,b)=> a.element1 < b.element1? 1 : 0);

    for(Pair<double,String> p in pairs ) {
      if (p.element1 > .4)
        similarStrings.add(p.element2);
      else break;
    }

    print("DOHA DUHA ${StringSimilarity.compareTwoStrings("doha","duha")}");
    return similarStrings.toList();
  }

  List<Product> _convertFromNameToProduct(List<String> productNames){
    List<Product> products = [];
    for(String s in productNames){
      products.add(_fromNameToProduct[s]);
    }
    return products;
  }
}
