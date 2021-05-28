import 'package:flutter/cupertino.dart';

class SelectedCategoryNotifier extends ChangeNotifier {
  int _selectedIndex= 0;
  bool _isAllSelected = false;

  int get selectedIndex =>_selectedIndex;
  bool get isAllSelected => _isAllSelected;
  SelectedCategoryNotifier(this._selectedIndex,this._isAllSelected);
  void ChangeSelectedIndex(int x) {
    _isAllSelected = false;
    _selectedIndex = x;
    notifyListeners();
  }
  void isALLSELECTED(bool x) {
    _isAllSelected = x;
    notifyListeners();
  }
}