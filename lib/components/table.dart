import 'package:flutter/material.dart';

import 'list.dart';
import 'common.dart';

import '../models/table.dart';
import '../models/list.dart';

class TableWidget extends StatefulWidget {
  final String path;

  TableWidget({Key key, this.path}) : super(key: key);

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  static const titleFontStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 40);
  Future<TableModel> futureTableModel;

  @override
  void initState() {
    super.initState();
    futureTableModel = fetchTable(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _renderTitle(),
        Divider(
          height: 10,
          thickness: 2,
        ),
        Expanded(child: _renderTableList()),
      ],
    );
  }

  // Builds Top bar
  Widget _renderTitle() {
    // TODO : Search Bar
    // TOOD : top animation controls
    String title = widget.path.split('/')[1];

    return Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(20, 40, 0, 10),
            child: Text(title, style: titleFontStyle)),
        // TextField(
        //   decoration: InputDecoration(
        //     labelText: "Search",
        //   ),
        // )
      ],
    );
  }

  // Builds GridView
  Widget _renderTableList() {
    return Container(
        decoration: BoxDecoration(color: Color.fromARGB(1, 244, 244, 244)),
        child: _handleFuture());
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
            children: _renderElements(snapshot),
            childAspectRatio: 0.75,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return loading();
      },
    );
  }

  void onGridItemTap(String path, String title) {
    Navigator.pushNamed(context, ListWidget.routeName,
        arguments: ListArgs(path, title));
  }

  // Builds GridView Items
  List<Widget> _renderElements(snapshot) {
    List<Widget> elements = List<Widget>();
    TextStyle smallTitleFontStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

    for (final e in snapshot.data.elements) {
      elements.add(Container(
          child: Card(
              elevation: 10,
              child: InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.network(e.thumbnail),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        alignment: Alignment.center,
                        child: Text(
                          e.title,
                          style: smallTitleFontStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  onTap: () => onGridItemTap(e.path, e.title)))));
    }
    return elements;
  }
}

class TableList extends StatefulWidget {
  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  static const List<String> tablePaths = ["/웹툰", "/단행본", "/망가", "/포토툰"];
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> items = tablePaths
      .map((tablePath) => BottomNavigationBarItem(
          icon: Icon(Icons.home), label: tablePath.split('/')[1]))
      .toList();

  final List<TableWidget> tables = tablePaths
      .map((tablePath) => new TableWidget(key: UniqueKey(), path: tablePath))
      .toList();

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tables.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
