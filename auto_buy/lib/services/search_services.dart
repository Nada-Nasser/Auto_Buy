import 'package:auto_buy/models/Pair.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:string_similarity/string_similarity.dart';

class searchServices {

  List<Product> _allProducts = [];
  List<String> _productNamesList = [];
  final Map<String, Product> _fromNameToProduct = {};

  searchServices() {
    print("search service intilised");
    readAllProducts();
  }

  bool hasProducts(){
    return _allProducts.isNotEmpty;
  }
  Future<List<Product>> readAllProducts() async{
    _allProducts = await ProductsBackendServices().ReadProductsFromFirestore();
      for (Product prod in _allProducts) {
        _fromNameToProduct[prod.name.toLowerCase()] = prod;
        _productNamesList.add(prod.name.toLowerCase());
      }
      print(_fromNameToProduct);
      return _allProducts;
  }
  List<Product> search(String searchTerm) {
    List<String> similarStrings = searchReturnsNames(searchTerm);
    List<Product> products = [];
    if(similarStrings.isNotEmpty)
      products = convertFromNameToProduct(similarStrings);

    return products;
  }

  List<String> searchReturnsNames(String searchTerm) {
    Set<String> similarStrings =  new Set<String>();
    List<Pair<double,String>> pairs = [];

    for(String s in _productNamesList){
      pairs.add(Pair(s.similarityTo(searchTerm) , s));
      if(s.contains(searchTerm)) {
        similarStrings.add(s);
      }
      print("SIMILARITY OF $searchTerm = ${s.similarityTo(searchTerm)}");
    }
    pairs.sort((a,b)=> a.element1 < b.element1? 1 : 0);

    for(Pair<double,String> p in pairs ) {
      if (p.element1 > .4)
        similarStrings.add(p.element2);
      else break;
    }

    return similarStrings.toList();
  }

  List<Product> convertFromNameToProduct(List<String> productNames){
    List<Product> products = [];
    for(String s in productNames){
      products.add(_fromNameToProduct[s]);
    }
    return products;
  }
}
