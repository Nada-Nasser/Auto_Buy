import 'package:auto_buy/models/Category.dart';
import 'package:auto_buy/screens/Categories/backEnd/SelectedCategoryNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainCategoriesListView extends StatefulWidget {
  List<category> categories = [];
  int _selectedIndex = 0;
  MainCategoriesListView( {@required this.categories});

  @override
  _MainCategoriesListViewState createState() => _MainCategoriesListViewState();
}

class _MainCategoriesListViewState extends State<MainCategoriesListView> {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: widget.categories.length,
        itemExtent: 70.0,
        padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
        itemBuilder: (context, indx) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                left: (indx == widget._selectedIndex)//only selected tile will have an orange border
                    ? BorderSide(width: 3.0, color: Colors.orangeAccent)
                    : BorderSide(width: 0, color: Colors.orangeAccent),
              ),
            ),
            child: ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 0),
              child: ListTile(
                  dense: true,
                  selected: indx == widget._selectedIndex,
                  tileColor: Colors.white,
                  selectedTileColor: Colors.transparent,
                  subtitle: Center(
                    child: Text(widget.categories[indx].name,
                        maxLines: 3,
                        textWidthBasis: TextWidthBasis.longestLine,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    setState(() { // when selected change _selectedIndx
                      widget._selectedIndex = indx;
                      Provider.of<SelectedCategoryNotifier>(context,listen: false).ChangeSelectedIndex(indx);
                    });
                  }),
            ),
          );
        });
  }
}
