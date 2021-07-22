import 'package:flutter/cupertino.dart';

class SelectedCategoryNotifier extends ChangeNotifier {
  int _selectedIndex= 0;
  int _isAllSelected = 0;
  String _subCategory;

  int get selectedIndex =>_selectedIndex;
  int get isAllSelected => _isAllSelected;
  String get subCategory => _subCategory;


  SelectedCategoryNotifier(this._selectedIndex,this._isAllSelected);
  void ChangeSelectedIndex(int x) {
    _isAllSelected = 0;
    _selectedIndex = x;
    notifyListeners();
  }
  void isALLSELECTED(int x) {
    _isAllSelected = x;
    notifyListeners();
  }

  void isALLSubCategSELECTED(int x,String subCategory) {
    _isAllSelected = x;
    _subCategory = subCategory;
    notifyListeners();
  }
}