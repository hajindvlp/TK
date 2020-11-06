import 'package:flutter/material.dart';

import 'package:tk/components/table_title.dart';
import 'package:tk/components/table.dart';

class ToonTable extends StatefulWidget {
  static const routeName = "/";
  final String title;

  ToonTable(this.title);

  @override
  _ToonTableState createState() => _ToonTableState();
}

class _ToonTableState extends State<ToonTable> {
  @override
  Widget build(BuildContext context) {
    String path = '/${widget.title}';
    return Scaffold(
      body: Column(
        children: [
          TableTitle(widget.title),
          TableWidget(
            path: path,
            key: UniqueKey(),
          ),
        ],
      ),
    );
  }
}
