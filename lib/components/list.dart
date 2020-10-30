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
          crossAxisAlignment: CrossAxisAlignment.start,
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

  // TODO : change hyphens to space
  // TODO : Image & Scrolling thingy
  Widget _renderTitle() {
    const TextStyle titleStyle = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
    const double iconSize = 30;
    String title = widget.title.replaceAll("-", " ");

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
              child: Icon(Icons.arrow_back_ios_outlined, size: iconSize),
            ),
            onTap: () { Navigator.pop(context); },
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Text(title, style: titleStyle, overflow: TextOverflow.fade),
          ),
        ],
      ),
    );
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

    for (var i = 0; i < snapshot.data.elements.length; i++) {
      ListElement e = snapshot.data.elements.elementAt(i);
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
                  onListTileTap(i, snapshot.data.elements);
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

  void onListTileTap(int idx, List<ListElement> elements) {
    Navigator.pushNamed(context, ViewWidget.routeName,
        arguments: ViewArgs(idx, elements));
  }
}
