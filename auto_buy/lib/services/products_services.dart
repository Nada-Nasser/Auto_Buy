import 'package:auto_buy/models/product_model.dart';
import 'package:auto_buy/models/product_rate.dart';

import 'firebase_backend/api_paths.dart';
import 'firebase_backend/firestore_service.dart';
import 'firebase_backend/storage_service.dart';

class ProductsBackendServices {
  final _firestoreService = CloudFirestoreService.instance;
  final _storageService = FirebaseStorageService.instance;

  List<Product> allProducts = [];
  Map<String, String> picturePath = {};

  ProductsBackendServices._();

  static ProductsBackendServices instance = ProductsBackendServices._();

  Stream<Product> getProductStream(String productID) =>
      _firestoreService.documentStream(
        path: APIPath.productPath(productID: productID),
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );

  Future<List<Rate>> readProductRates(String productId) async {
    List<Rate> rates = await _firestoreService.getCollectionData(
        collectionPath: APIPath.productRatesCollectionPath(productId),
        builder: (data, documentId) => Rate.fromMap(data, documentId));

    return rates;
  }

  Future<void> rateProductWithNStars(int n, String uid,
      String productID) async {
    try {
      Rate rate = Rate(nStars: n, id: uid);
      await _firestoreService.setDocument(
        documentPath: APIPath.userRateOnProductDocumentPath(productID, uid),
        data: rate.toMap(),
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<Product> readProduct(String productID) async {
    Product product = await _firestoreService.readOnceDocumentData(
      collectionPath: APIPath.productsPath(),
      documentId: productID,
      builder: (data, documentID) => Product.fromMap(data, documentID),
    );

    String url = await _storageService.downloadURL(product.picturePath);
    product.picturePath = url;
    return product;
  }

  Future<double> getProductPrice(String productID) async {
    Product product = await readProduct(productID);
    if (product.hasDiscount)
      return product.priceAfterDiscount;
    else
      return product.price;
  }

  Future<List<Product>> readCategoryProducts(String categoryID) async {
    print('CATEGORY ID :  $categoryID');
    List<Product> products = await _firestoreService.getCollectionData(
      collectionPath: '/products',
      builder: (value, id) => Product.fromMap(value, id),
      queryBuilder: (query) =>
          query.where('category_id', isEqualTo: categoryID),
    );

    for (int i = 0; i < products.length; i++) {
      String url = await _storageService.downloadURL(products[i].picturePath);
      products[i].picturePath = url;
    }

    return products;
  }

  Future<List<Product>> readProductsFromFirestore() async {
    if (allProducts.length > 0) {
      for (int i = 0; i < allProducts.length; i++) {
        try {
          String url =
              await _storageService.downloadURL(picturePath[allProducts[i].id]);
          allProducts[i].picturePath = url;
        } on Exception catch (e) {
          print(e);
        }
      }
      return allProducts;
    }

    allProducts = [];
    picturePath.clear();
    allProducts = await _firestoreService.getCollectionData(
      collectionPath: APIPath.productsPath(),
      builder: (value, id) => Product.fromMap(value, id),
      queryBuilder: (query) => query.where('name', isNotEqualTo: ""),
    );

    for (int i = 0; i < allProducts.length; i++) {
      final path = allProducts[i].picturePath;
      picturePath[allProducts[i].id] = path;

      try {
        String url =
            await _storageService.downloadURL(allProducts[i].picturePath);
        allProducts[i].picturePath = url;
      } on Exception catch (e) {
        print(e);
      }
    }
    return allProducts;
  }
}
