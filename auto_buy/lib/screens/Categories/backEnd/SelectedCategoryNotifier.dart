import 'package:flutter/cupertino.dart';

class SelectedCategoryNotifier extends ChangeNotifier {
  int _selectedIndex= 0;

  int get selectedIndex =>_selectedIndex;

  SelectedCategoryNotifier(this._selectedIndex);
  void ChangeSelectedIndex(int x) {
    _selectedIndex = x;
    notifyListeners();
  }
}