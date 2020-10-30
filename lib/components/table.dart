import 'package:flutter/material.dart';

import 'list.dart';
import 'common.dart';
import 'setting.dart';

import '../models/table.dart';
import '../models/list.dart';

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
  // TODO : Search bar animation
  // TODO : Controls animation
  Widget _renderTitle() {
    String title = widget.path.split('/')[1];
    const double iconSize = 40;
    const TextStyle titleStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: titleStyle),
          Spacer(),
          Center(child: Icon(Icons.search, size: iconSize)),
          SizedBox(width: 10),
          Center(child:
            RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.arrow_forward_ios, size: iconSize),
            )
          ),
        ],
      ),
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
    TextStyle listTitleStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

    for (final e in snapshot.data.elements) {
      elements.add(Card(
        elevation: 10,
        child: InkWell(
          onTap: () => onGridItemTap(e.path, e.title),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(e.thumbnail),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                alignment: Alignment.center,
                child: Text(e.title, style: listTitleStyle, overflow: TextOverflow.ellipsis,),
              )
            ],
          ),
        ),
      ));
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
  static const List<String> tableLabels = ["웹툰", "단행본", "망가", "포토툰", "설정"];
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.all_inbox),
      label: tableLabels[0],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: tableLabels[1],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.backup_table),
      label: tableLabels[2],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.camera_alt),
      label: tableLabels[3],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: tableLabels[4],
    ),
  ];

  final List<Widget> tables = <Widget>[
    TableWidget(key: UniqueKey(), path: tablePaths[0],),
    TableWidget(key: UniqueKey(), path: tablePaths[1],),
    TableWidget(key: UniqueKey(), path: tablePaths[2],),
    TableWidget(key: UniqueKey(), path: tablePaths[3],),
    Setting(),
  ];

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
        unselectedItemColor: Colors.black12,
        items: items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
