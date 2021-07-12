import 'package:auto_buy/models/expense_model.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';

class ExpenseTrackerServices {
  CloudFirestoreService _firestoreService = CloudFirestoreService.instance;

  Future<List<Expense>> fetchAllUserExpenses(String uid) async {
    String log = "ExpenseTrackerServices(fetchAllUserExpenses):";

    // print("$log Start Fetching User expenses");

    bool flag =
        await _firestoreService.checkExist(docPath: APIPath.userOrdersIDs(uid));
    if (!flag) {
      // print("$log There is no User expenses");
      return [];
    }

    List<Expense> expenses = [];
    List<dynamic> orderIDs = await _firestoreService.readOnceDocumentData(
        documentId: uid,
        collectionPath: "/users_orders",
        builder: (Map<String, dynamic> data, String documentId) =>
            data['orders_ids']);

    //print("$log End Fetching User expenses");

    for (int i = 0; i < orderIDs.length; i++) {
      Expense order = await _firestoreService.readOnceDocumentData(
        collectionPath: "/orders/",
        documentId: "${orderIDs[i]}",
        builder: (values, id) => Expense.fromMap(values, id),
      );

      for (int j = 0; j < order.productsID.length; j++) {
        String productId = order.productsID[j];
        final productAndCategoryPair =
            await _firestoreService.readOnceDocumentData(
          collectionPath: APIPath.productsPath(),
          documentId: productId,
          builder: (data, id) => ProductAndCategoryPair.fromMap(data, id),
        );

        final category = productAndCategoryPair.categoryName;
        final productName = productAndCategoryPair.productName;

        order.productCategoryNames.add(category);
        order.productsName.add(productName);

        final price = order.prices[productId] * order.quantities[productId];
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

class ProductAndCategoryPair {
  final String productName;
  final String categoryName;

  ProductAndCategoryPair({this.productName, this.categoryName});

  factory ProductAndCategoryPair.fromMap(Map<String, dynamic> data, String id) {
    return ProductAndCategoryPair(
        categoryName: data['category_id'], productName: data['name']);
  }
}