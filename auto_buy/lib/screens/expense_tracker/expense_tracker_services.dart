import 'package:auto_buy/models/expense_model.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';

class ExpenseTrackerServices {
  CloudFirestoreService _firestoreService = CloudFirestoreService.instance;

  Future<List<Expense>> fetchAllUserExpenses(String uid) async {
    String log = "ExpenseTrackerServices(fetchAllUserExpenses):";

    print("$log Start Fetching User expenses");

    List<Expense> expenses = [];
    List<dynamic> orderIDs = await _firestoreService.readOnceDocumentData(
        documentId: uid,
        collectionPath: "/users_orders",
        builder: (Map<String, dynamic> data, String documentId) =>
            data['orders_ids']);

    print("$log End Fetching User expenses");
    print(orderIDs);

    for (int i = 0; i < orderIDs.length; i++) {
      print("ORDER : ${orderIDs[i]}");

      Expense order = await _firestoreService.readOnceDocumentData(
        collectionPath: "/orders/",
        documentId: "${orderIDs[i]}",
        builder: (values, id) => Expense.fromMap(values, id),
      );

      for (int j = 0; j < order.productsID.length; j++) {
        String productId = order.productsID[j];
        print(productId);

        CategoryAndPrice categoryAndPrice =
            await _firestoreService.readOnceDocumentData(
          collectionPath: APIPath.productsPath(),
          documentId: productId,
          builder: (values, id) => CategoryAndPrice.fromMap(values, id),
        );

        order.productCategoryNames.add(categoryAndPrice.category);
        order.productsPrices.add(categoryAndPrice.price);
        final category = categoryAndPrice.category;
        final price = categoryAndPrice.price * order.quantities[productId];

        print("$category : $price");

        if (order.categoryAndPrice[category] != null)
          order.categoryAndPrice[category] += price;
        else
          order.categoryAndPrice[category] = price;
      }

      expenses.add(order);
    }
    expenses = _sortExpenses(expenses);

    print(expenses);

    return expenses;
  }

  List<Expense> _sortExpenses(List<Expense> expenses, {bool reversed: false}) {
    expenses.sort((a, b) {
      return a.compareTo(b);
    });

    if (reversed) {
      expenses = expenses.reversed.toList();
    }

    return expenses;
  }
}

class CategoryAndPrice {
  final productID;
  final String category;
  final double price;

  CategoryAndPrice({this.category, this.price, this.productID});

  factory CategoryAndPrice.fromMap(Map<String, dynamic> value, String id) {
    return CategoryAndPrice(
      productID: id,
      price: double.parse('${value['price']}'),
      category: value['category_id'],
    );
  }

  @override
  String toString() {
    return 'CategoryAndPrice{productID: $productID, category: $category, price: $price}';
  }
}