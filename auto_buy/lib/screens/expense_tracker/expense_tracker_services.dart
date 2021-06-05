import 'package:auto_buy/models/expense_model.dart';
import 'package:auto_buy/services/firebase_backend/api_paths.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';

class ExpenseTrackerServices {
  CloudFirestoreService _firestoreService = CloudFirestoreService.instance;

  Future<List<Expense>> fetchAllUserExpenses(String uid) async {
    List<Expense> expenses = [];
    List<String> orderIDs = await _firestoreService.getCollectionData(
        collectionPath: APIPath.userOrdersIDs(uid),
        builder: (Map<String, dynamic> data, String documentId) =>
            data['order_ids']);

    for (int i = 0; i < orderIDs.length; i++) {
      Expense expense = await _firestoreService.readOnceDocumentData(
        collectionPath: "/orders/",
        documentId: "${orderIDs[i]}",
        builder: (values, id) => Expense.fromMap(values, id),
      );

      for (int j = 0; j < expense.productsID.length; i++) {
        String category = await _firestoreService.readFieldValueFromDocument(
          collectionPath: APIPath.productsPath(),
          documentID: expense.productsID[i],
          fieldName: "category_id",
        );
        expense.productCategoryNames.add(category);
      }
      expenses.add(expense);
    }
    expenses = _sortExpenses(expenses);
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
