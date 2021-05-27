import 'package:flutter/cupertino.dart';

class SelectedCategoryNotifier extends ChangeNotifier {
  int _selectedIndex= 0;
  int _isAllSelected = 0;

  int get selectedIndex =>_selectedIndex;
  int get isAllSelected => _isAllSelected;
  SelectedCategoryNotifier(this._selectedIndex,this._isAllSelected);
  void ChangeSelectedIndex(int x) {
    _selectedIndex = x;
    notifyListeners();
  }
  void isALLSELECTED(int x) {
    _isAllSelected = x;
    notifyListeners();
  }
}