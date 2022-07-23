import 'package:flutter/cupertino.dart';

class RentXList extends StatelessWidget {
  const RentXList({Key? key, required this.items, required this.itemsPerRow})
      : super(key: key);

  final List<Widget> items;
  final int itemsPerRow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildRows(),
    );
  }

  List<Row> _buildRows() {
    List<Row> rows = [];
    var ctr = 0;
    List<Widget> rowChildren = [];
    for (Widget widget in items) {
      if (ctr == itemsPerRow) {
        rows.add(Row(
          children: rowChildren,
        ));
        ctr = 0;
        rowChildren = [];
      }
      rowChildren.add(widget);
      ctr++;
    }
    if (rowChildren.isNotEmpty) {
      rows.add(Row(
        children: rowChildren,
      ));
    }
    return rows;
  }
}
