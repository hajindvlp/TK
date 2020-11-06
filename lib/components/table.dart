import 'package:flutter/material.dart';

import 'common.dart';
import 'intro_card.dart';

import '../models/table.dart';

class TableWidget extends StatefulWidget {
  final String path;

  TableWidget({Key key, this.path}) : super(key: key);

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  Future<TableModel> futureTableModel;

  @override
  void initState() {
    super.initState();
    futureTableModel = fetchTable(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(1, 244, 244, 244)),
        child: _handleFuture(),
      ),
    );
  }

  FutureBuilder<TableModel> _handleFuture() {
    return FutureBuilder<TableModel>(
      future: futureTableModel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.count(
            padding: EdgeInsets.all(10),
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 10,
            children: _buildElements(snapshot),
            childAspectRatio: 0.75,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return loading();
      },
    );
  }

  List<Widget> _buildElements(snapshot) {
    List<Widget> elements = List<Widget>();

    for (final e in snapshot.data.elements) {
      elements.add(IntroCard(
        imgSrc: e.thumbnail,
        path: e.path,
        title: e.title,
        summary: e.summary,
      ));
    }
    return elements;
  }
}
