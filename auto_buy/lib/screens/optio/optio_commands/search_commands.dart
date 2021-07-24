
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/product_info_screen/product_info_screen.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/widgets/products_list_dialog.dart';
import 'package:flutter/material.dart';

import 'command.dart';

class SearchCommand implements Command{

  Product _selectedProduct;

  @override
  final CommandArguments commandArguments;
  SearchCommand(this.commandArguments);

  @override
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;

  @override
  Future<void> run(ProductSearchServices searchService) async {
    List<Product> searchProducts =
        await getSearchResults(commandArguments.productsName, searchService);
    await productsListDialog(
      commandArguments.context,
      _onSelectProduct,
      searchProducts,
      "Search Results",
    );
    if (_selectedProduct == null)
      throw Exception("You didn't select a product");
    else
      goToProductInfo(commandArguments.context, _selectedProduct);
  }

  Future<List<Product>> getSearchResults(
      String term, ProductSearchServices searchService) async {
    return searchService.search(term);
  }

  Future<void> _onSelectProduct(BuildContext context, Product product) async {
    _selectedProduct = product;
  }

  Future<void> goToProductInfo(BuildContext context, Product product) {
    return Navigator.of(commandArguments.context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductInfoScreen.create(
          context,
          product,
          product.picturePath,
        ),
      ),
    );
  }

}