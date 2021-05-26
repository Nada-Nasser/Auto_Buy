import 'package:auto_buy/models/Category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryListView extends StatefulWidget {
  List<category> categories = [];
  int _selectedIndex = 0;

  CategoryListView({@required this.categories});

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                        textWidthBasis: TextWidthBasis.longestLine),
                  ),
                  onTap: () {
                    setState(() { // when selected change _selectedIndx
                      widget._selectedIndex = indx;
                    });
                  }),
            ),
          );
        });
  }
}
