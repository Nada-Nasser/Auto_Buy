import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/shopping_cart_item.dart';
import 'package:auto_buy/screens/optio/optio_commands/command.dart';
import 'package:auto_buy/screens/shopping_cart/shopping_cart_screen.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/services/products_services.dart';
import 'package:auto_buy/services/shopping_cart_services.dart';
import 'package:auto_buy/widgets/products_list_dialog.dart';
import 'package:flutter/material.dart';

class ShoppingCartCommand implements Command{
  @override
  final CommandArguments commandArguments;
  ShoppingCartCommand(this.commandArguments);
  final ProductsBackendServices _productsBackendServices = ProductsBackendServices();
  final ShoppingCartServices shoppingCartServices = ShoppingCartServices();
  Product selectedProduct;

  @override
  bool get isValidCommand => commandArguments.commandType != CommandType.INVALID;

  @override
  Future<void> run(ProductSearchServices searchService) async {
    if (commandArguments.commandType == CommandType.ADD) {
      await _addToShoppingCart(searchService);
    } else if (commandArguments.commandType == CommandType.DELETE) {
      await _deleteFromShoppingCart();
    } else if (commandArguments.commandType == CommandType.OPEN) {
      _openShoppingCart();
    } else {
      throw Exception('you can\'t do this command with your shopping cart');
    }
  }

  Future<void> _addToShoppingCart(ProductSearchServices searchService) async {
    try {
      List<Product> products =
          await getSearchResults(commandArguments.productsName, searchService);

      ///select a product
      await productsListDialog(
        commandArguments.context,
        _onSelectProduct,
        products,
        "Select the Product that you want",
      );

      ///check if there's still quantity in stock
      if (selectedProduct == null)
        throw Exception('You did not select a product');
      if (selectedProduct.numberInStock == 0)
        throw Exception('The product is out of stock');
      if (commandArguments.quantity > selectedProduct.numberInStock)
        throw Exception(
            'only ${selectedProduct.numberInStock} of this product left in stock');

      ///create a cart item
      if (_didntExceedMax()) {
        final cartItem = ShoppingCartItem(
          quantity: commandArguments.quantity,
          lastModifiedDat: DateTime.now(),
          totalPrice: selectedProduct.hasDiscount
              ? commandArguments.quantity * selectedProduct.priceAfterDiscount
              : commandArguments.quantity * selectedProduct.price,
          productID: selectedProduct.id,
        );
        shoppingCartServices.addProductToUserShoppingCart(
            commandArguments.uid, cartItem, selectedProduct.numberInStock);
        throw Exception(
            "Product named ${selectedProduct.name} added to your shopping cart");
      } else {
        throw Exception(
            'Couldn\'t add the product because you exceeded the demand limit');
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<Product>> getSearchResults(
      String term, ProductSearchServices searchService) async {
    return searchService.search(term);
  }

  Future<void> _deleteFromShoppingCart() async {
    try {
      List<Product> shoppingCartProducts = [];
      List<Product> products = [];
      //first get all products from user's cart
      dynamic cartItems = await CloudFirestoreService.instance
          .getCollectionData(
              collectionPath:
                  "shopping_carts/${commandArguments.uid}/shopping_cart_items/",
              builder: (Map<String, dynamic> data, String documentId) {
                Map<String, dynamic> output = {"data": data, "id": documentId};
                return output;
              });
      //create products from cart
      if (cartItems.length > 0) {
        for (int i = 0; i < cartItems.length; i++) {
          Product product = await _productsBackendServices
              .readProduct("${cartItems[i]['id']}");
          shoppingCartProducts.add(product);
          print(product.picturePath);
        }
        if (commandArguments.productsName.isEmpty)
          products = shoppingCartProducts;
        else {
          products = [];
          List<String> productNameList =
              commandArguments.productsName.split(" ");
          for (int i = 0; i < shoppingCartProducts.length; i++) {
            bool flag = false;
            for (int j = 0; j < productNameList.length; j++) {
              if (shoppingCartProducts[i]
                  .name
                  .toLowerCase()
                  .contains(productNameList[j].toLowerCase())) {
                flag = true;
                break;
              }
            }
            if (flag) {
              products.add(shoppingCartProducts[i]);
            }
          }
        }

        if (products.isEmpty) {
          throw Exception(
              "There is not any product with name ${commandArguments.productsName} in your shopping cart");
        }

        await productsListDialog(
          commandArguments.context,
          _onSelectProduct,
          products,
          "Select a Product to delete",
        );

        if (selectedProduct == null)
          throw Exception('you did not select a product');

        //delete selected product
        await CloudFirestoreService.instance.deleteDocument(
            path:
                "shopping_carts/${commandArguments.uid}/shopping_cart_items/${selectedProduct.id}");
        throw Exception(
            'Product named ${selectedProduct.name} Deleted from the shopping cart');
      } else {
        throw Exception("cart is empty");
      }
    } on Exception {
      rethrow;
    }
  }
  void _openShoppingCart(){
    Navigator.of(commandArguments.context).push(MaterialPageRoute(builder: (context)=>ShoppingCartScreen()));
  }

  bool _didntExceedMax(){
    if(commandArguments.quantity > selectedProduct.maxDemandPerUser)
      return false;
    else
      return true;
  }



  Future<void> _onSelectProduct(BuildContext context, Product product) async {
    selectedProduct = product;
  }

}
