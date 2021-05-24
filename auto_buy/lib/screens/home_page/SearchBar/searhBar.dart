
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BackEnd/UI_for_search_results.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  static const HistoryLenght = 10;
  List<String> _searchHistory = [];
  List<String> _filteredSearchHistory;
  List<String> _productNamesList = [];

  List<Product> Products = [];
  List<Product> chosenProduct = [];
  String selectedTerm;
  final _firestoreService = CloudFirestoreService.instance;
  final _storageService = FirebaseStorageService.instance;
  final Map<String, Product> fromNameToProduct = {};
  bool FirstSearch = true;

  Future<void> _readHistorySharedPrefrence() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'searchHistory';
    setState(() {
      _searchHistory = prefs.getStringList(key) ?? [];
    });
    _filteredSearchHistory = filterSearchTerms(filter: null);

  }
  _saveHistorySharedPrefrence() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'searchHistory';
    prefs.setStringList(key, _searchHistory);
  }
  void search(selectedTerm) {
    chosenProduct.clear();
    if(selectedTerm != "" && selectedTerm != Null) {
      if (fromNameToProduct.containsKey(selectedTerm)) {
        chosenProduct.add(fromNameToProduct[selectedTerm]);
      }
      else {
        List<String> temp = filterSearchTerms(filter: selectedTerm);
        for (String s in temp) {
          chosenProduct.add(fromNameToProduct[s]);
        }
      }
    }
  }

  Future<List<Product>> ReadProducts() async {
    Products = await ReadProductsFromFirestore();
    for (Product prod in Products) {
      fromNameToProduct[prod.name.toLowerCase()] = prod;
      _productNamesList.add(prod.name.toLowerCase());
    }
    print(fromNameToProduct);
  }

  Future<List<Product>> ReadProductsFromFirestore() async {
    List<Product> products = await _firestoreService.getCollectionData(
      collectionPath: APIPath.productsPath(),
      builder: (value, id) => Product.fromMap(value, id),
      queryBuilder: (query) => query.where('name', isNotEqualTo: ""),
    );
    for (int i = 0; i < products.length; i++) {
      String url = await _storageService.downloadURL(products[i].picturePath);
      products[i].picturePath = url;
    }
    return products;
  }

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      filter = filter.toLowerCase();
      return _productNamesList.where((term) => term.contains(filter)).toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > HistoryLenght) {
      _searchHistory.removeRange(0, _searchHistory.length - HistoryLenght);
    }
    _filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    _filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  FloatingSearchBar FSB() {
    return FloatingSearchBar(
      margins: EdgeInsets.fromLTRB(5, 45, 5, 0),
      borderRadius: const BorderRadius.all(
        const Radius.circular(8.0),
      ),
      controller: controller,
      transition: CircularFloatingSearchBarTransition(),
      // Bouncing physics for the search history
      physics: BouncingScrollPhysics(),
      // Title is displayed on an unopened (inactive) search bar
      title: Text(
        selectedTerm ?? 'what are you looking for?',
        style: Theme
            .of(context)
            .textTheme
            .bodyText1,
      ),
      // Hint gets displayed once the search bar is tapped and opened
      hint: 'Search and find out...',
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],

      onQueryChanged: (query) {
        setState(() {
          _filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          if (selectedTerm != "") {
            addSearchTerm(query);
            selectedTerm = query;

            /// dah lama 7d ydoos zorar el search 3la klma msh zahralo f el list
            search(selectedTerm);
          }
        });

        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Builder(
              builder: (context) {
                if (_filteredSearchHistory.isEmpty &&
                    controller.query.isEmpty) {
                  return Container(
                    height: 57,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Start searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption,
                    ),
                  );
                } else if (_filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        addSearchTerm(controller.query);
                        selectedTerm = controller.query;
                      });
                      controller.close();
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _filteredSearchHistory
                        .map(
                          (term) =>
                          ListTile(
                            title: Text(
                              term,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(Icons.history),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  deleteSearchTerm(term);
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                putSearchTermFirst(term);
                                selectedTerm = term;
                                search(selectedTerm);
                              });
                              controller.close();
                            },
                          ),
                    )
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Container ErrorMsg() {
    return Container(
        height: 500,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              Text(
                'Oops! No results for $selectedTerm',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              Text(
                'check your spelling for typing errors.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 2, fontSize: 20),
              ),
            ],
          ),
        ));
  }

  ProductPrettyListView gridList(List<Product> productsList) {
    return ProductPrettyListView(productsList: productsList);
  }

  @override
  Future<void> initState() {
    FirstSearch = false;
    controller = FloatingSearchBarController();
    ReadProducts();
    _readHistorySharedPrefrence();
    super.initState();

  }

  @override
  void dispose() {
    controller.dispose();
    _saveHistorySharedPrefrence();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    ProductsListView PLV = ProductsListView(
      height: MediaQuery
          .of(context)
          .size
          .height,
      productsList: chosenProduct,
      isHorizontal: false,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FSB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 4.0,
      ),
      body: ((chosenProduct.isEmpty && selectedTerm != null)) ? ErrorMsg() : gridList(chosenProduct));
  }
}
