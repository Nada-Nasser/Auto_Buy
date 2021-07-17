import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/widgets/vertical_list_view/vertical_products_list_view.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:auto_buy/widgets/products_list_view/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BackEnd/UI_for_search_results.dart';

class SearchBarScreen extends StatefulWidget {
  String term;
  ProductSearchServices sv;

  SearchBarScreen({String this.term = "", ProductSearchServices this.sv});

  @override
  SearchBarState createState() => SearchBarState(s: term , sv: sv);
}

class SearchBarState extends State<SearchBarScreen> {
  SearchBarState({String s = "" , ProductSearchServices sv}){
    selectedTerm = s;
    searchService = sv;
  }
  static const HistoryLenght = 10;
  List<String> _searchHistory = [];
  List<String> _filteredSearchHistory = [];
  List<String> _productNamesList = [];

  List<Product> Products = [];
  List<Product> chosenProduct = [];
  String selectedTerm;
  final Map<String, Product> fromNameToProduct = {};
  bool FirstSearch = true;

  ProductSearchServices searchService;


  Future<void> _readHistorySharedPrefrence() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'searchHistory';
    _searchHistory = prefs.getStringList(key) ?? [];
    _filteredSearchHistory = await filterSearchTerms(filter: null);
  }

  _saveHistorySharedPrefrence() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'searchHistory';
    prefs.setStringList(key, _searchHistory);
  }
  void search(selectedTerm) {
    chosenProduct.clear();
    if (selectedTerm != "" && selectedTerm != Null) {
      chosenProduct = searchService.search(selectedTerm);
    }
  }


  CreateFromNameToProductMap() {
    for (Product prod in Products) {
      fromNameToProduct[prod.name.toLowerCase()] = prod;
      _productNamesList.add(prod.name.toLowerCase());
    }
    print(fromNameToProduct);
  }

  List<String> filterSearchTerms({
    @required String filter,
  })  {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      filter = filter.toLowerCase();
      return searchService.searchReturnsNames(filter);
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
      margins: EdgeInsets.fromLTRB(5, 50, 5, 0),
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
        style: Theme.of(context).textTheme.bodyText1,
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
                      style: Theme.of(context).textTheme.caption,
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
                          (term) => ListTile(
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
              Icon(
                Icons.search_off_rounded,
                color: Colors.black,
                size: 70,
              ),
              SizedBox(
                height: 30,
              ),
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
    return ProductPrettyListView(productsList: productsList,);
  }

  @override
  Future<void> initState() {
    FirstSearch = false;
    controller = FloatingSearchBarController();
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: SafeArea(child: FSB()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          elevation: 4.0,
        ),
        body: (chosenProduct.isEmpty && selectedTerm != null && selectedTerm != "")
            ? ErrorMsg()
            : VerticalProductsListView(productsList: chosenProduct));
  }
}
