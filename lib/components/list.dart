import 'package:flutter/material.dart';
import 'package:tk/models/list.dart';
import 'package:tk/models/view.dart';
import 'view.dart';
import 'common.dart';

class ListWidget extends StatefulWidget {
  static const String routeName = "/list";
  final String path;
  final String title;

  ListWidget(this.path, this.title, {Key key}) : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  static const titleFontStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 40);
  Future<ListModel> futureListModel;

  @override
  void initState() {
    super.initState();
    futureListModel = fetchList(widget.path, widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _renderTitle(),
        Divider(
          height: 10,
          thickness: 2,
        ),
        Expanded(child: _renderList()),
      ],
    ));
  }

  // TODO : Controls
  // TODO : change hyphens to space
  // TODO : Image & Scrolling thingy
  Widget _renderTitle() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(20, 40, 0, 10),
          child: Text(widget.title,
              style: titleFontStyle, overflow: TextOverflow.fade)),
    ]);
  }

  Widget _renderList() {
    return Container(
        decoration: BoxDecoration(color: Color.fromARGB(1, 244, 244, 244)),
        child: _handleFuture());
  }

  FutureBuilder<ListModel> _handleFuture() {
    return FutureBuilder<ListModel>(
        future: futureListModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              children: _renderListTile(snapshot),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return loading();
        });
  }

  // TODO : swipe to download or download checkbox
  List<Widget> _renderListTile(snapshot) {
    List<Widget> elements = List<Widget>();
    TextStyle titleFontStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    for (final e in snapshot.data.elements) {
      if (e.title != null) {
        elements.add(Column(
          children: [
            InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(children: [
                    Flexible(
                        child: Text(
                      e.title,
                      style: titleFontStyle,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ]),
                ),
                onTap: () {
                  onListTileTap(e.path, e.title);
                }),
            Divider(
              thickness: 2,
            )
          ],
        ));
      }
    }

    return elements;
  }

  void onListTileTap(String path, String title) {
    Navigator.pushNamed(context, ViewWidget.routeName,
        arguments: ViewArgs(path, title));
  }
}
