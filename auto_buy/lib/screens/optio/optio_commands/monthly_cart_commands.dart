import 'package:auto_buy/models/monthly_cart_product_item.dart';
import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/screens/monthly_supplies/monthly_carts_screen.dart';
import 'package:auto_buy/services/monthly_cart_services.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/widgets/products_list_dialog.dart';
import 'package:auto_buy/widgets/selection_dialog.dart';
import 'package:flutter/material.dart';

import 'command.dart';

class MonthlyCartCommand implements Command {
  @override
  final CommandArguments commandArguments;
  final MonthlyCartServices _monthlyCartServices = MonthlyCartServices();
  /// contains the parameters needed to execute run function
  /// ex. uid, productName, ...

  MonthlyCartCommand(this.commandArguments);

  Product _selectedProduct;
  String _selectedCartName;

  @override
  Future<void> run(ProductSearchServices searchService) async {
    print("monthly cart command is running");
    try {
      if (commandArguments.commandType == CommandType.ADD) {
        await _addToMonthlyCart(searchService);
      } else if (commandArguments.commandType == CommandType.DELETE) {
        await _deleteFromMonthlyCart();
      } else if (commandArguments.commandType == CommandType.OPEN) {
        await _openMonthlyCart();
      } else {
        throw Exception("unknown command type in monthly cart");
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> _addToMonthlyCart(ProductSearchServices searchService) async {
    try {
      List<Product> products =
          await getSearchResults(commandArguments.productsName, searchService);

      await productsListDialog(
        commandArguments.context,
        _onSelectProduct,
        products,
        "Select the product you mean",
      );

      if (_selectedProduct != null) {
        await _getSelectedCartName();

        if (_selectedCartName != null) {
          print(
              "add ${_selectedProduct.name} to $_selectedCartName monthly cart");
          MonthlyCartItem item = MonthlyCartItem(
              productId: _selectedProduct.id,
              quantity: commandArguments.quantity ?? 1);

          await _monthlyCartServices.addProductToMonthlyCart(
            commandArguments.uid,
            _selectedCartName,
            item,
          );
          throw Exception(
              "Product Named ${_selectedProduct.name} added to your $_selectedCartName monthly cart");
        } else {
          throw Exception("You didn't select a cart");
        }
      } else {
        throw Exception("You didn't select a product");
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<Product>> getSearchResults(
      String term, ProductSearchServices searchService) async {
    return searchService.search(term);
  }

  Future<void> _deleteFromMonthlyCart() async {
    try {
      await _getSelectedCartName();
      if (_selectedCartName == null)
        throw Exception("You didn't select a cart name");

      List<Product> products;
      List<Product> monthlyCartProducts =
          await _monthlyCartServices.readMonthlyCartProducts(
        commandArguments.uid,
        _selectedCartName,
      );

      if (monthlyCartProducts.isEmpty) {
        throw Exception("This cart is empty, you can not delete from it");
      }

      if (commandArguments.productsName.isEmpty)
        products = monthlyCartProducts;
      else {
        products = [];
        List<String> productNameList = commandArguments.productsName.split(" ");
        for (int i = 0; i < monthlyCartProducts.length; i++) {
          bool flag = false;
          for (int j = 0; j < productNameList.length; j++) {
            if (monthlyCartProducts[i]
                .name
                .toLowerCase()
                .contains(productNameList[j].toLowerCase())) {
              flag = true;
              break;
            }
          }
          if (flag) {
            products.add(monthlyCartProducts[i]);
          }
        }
      }

      if (products.isEmpty) {
        throw Exception(
            "There is not any product with name ${commandArguments.productsName} in your $_selectedCartName monthly cart");
      }

      await productsListDialog(
        commandArguments.context,
        _onSelectProduct,
        products,
        "Select Product you mean",
      );

      if (_selectedProduct != null) {
        await _monthlyCartServices.deleteProductFromMonthlyCart(
          commandArguments.uid,
          _selectedCartName,
          _selectedProduct.id,
        );
      } else {
        throw Exception("You didn't select a product");
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> _getSelectedCartName() async {
    List<String> cartNames = await _monthlyCartServices
        .readUserMonthlyCartsNames(commandArguments.uid);
    await selectionDialog(
      commandArguments.context,
      _onCartNameSelected,
      cartNames,
      "Monthly Cart Names",
      "Please select monthly cart name you want to add the product in.",
    );
  }

  @override
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;

  Future<void> _onSelectProduct(BuildContext context, Product product) async {
    _selectedProduct = product;
  }

  Future<void> _onCartNameSelected(BuildContext context, String name) async {
    _selectedCartName = name;
  }

  _openMonthlyCart() {
    Navigator.of(commandArguments.context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MonthlyCartsScreen.create(context),
      ),
    );
  }
}
