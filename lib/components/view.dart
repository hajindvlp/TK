import 'package:flutter/material.dart';
import 'package:tk/models/list.dart';
import '../models/view.dart';
import '../utils/fetchGet.dart';
import 'common.dart';

class ViewWidget extends StatefulWidget {
  static const String routeName = "/view";
  final String path;
  final String title;
  final int idx;
  final List<ListElement> elements;

  ViewWidget(this.idx, this.elements, {Key key})
      : assert(idx >= 0),
        path = elements.elementAt(idx).path,
        title = elements.elementAt(idx).title,
        super(key: key);

  @override
  _ViewWidgetState createState() => _ViewWidgetState();
}

class _ViewWidgetState extends State<ViewWidget> {
  bool _showControl = true;

  @override
  void initState() {
    super.initState();
    _showControl = true;
  }

  @override
  void didUpdateWidget(ViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      this.initState();
    }
  }

  GestureTapCallback toggleShowControl() {
    return () {
      setState(() {
        _showControl = !_showControl;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InkWell(
            onTap: toggleShowControl(),
            child: ListView(children: [
              ImageList(widget.path, widget.title),
            ]),
          ),
          if (_showControl) ...[
            _renderTopControl(),
            _renderBottomControl(),
          ],
        ],
      ),
    );
  }

  Widget _renderTopControl() {
    const BoxDecoration bottomBorder = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black38)),
      color: Colors.white,
    );
    const titleTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 8, 0, 8),
        decoration: bottomBorder,
        child: Row(
          children: [
            InkWell(
              child: Icon(Icons.arrow_back_ios, size: 24),
              onTap: () { Navigator.pop(context); },
            ),
            Text(widget.title, style: titleTextStyle, overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    );
  }

  Widget _renderBottomControl() {
    const BoxDecoration topBorder = BoxDecoration(
      border: Border(top: BorderSide(color: Colors.black38)),
      color: Colors.white,
    );
    const double iconSize = 32;
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.fromLTRB(0, 4, 10, 4),
        decoration: topBorder,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Icon(Icons.format_list_bulleted, size: iconSize),
              onTap: () { Navigator.pop(context); },
            ),
            SizedBox(width: 40),
            backIconButton(),
            SizedBox(width: 10),
            forwardIconButton(),
          ],
        ),
      ),
    );
  }

  Widget backIconButton() {
    int idx = widget.idx;
    List<ListElement> elements = widget.elements;
    Color color = Colors.black12;
    GestureTapCallback cb = () {};

    if(idx + 1 < elements.length && elements.elementAt(idx+1).title != null) {
      color = Colors.black;
      cb = () {
        Navigator.pushReplacementNamed(context, ViewWidget.routeName,
            arguments: ViewArgs(widget.idx + 1, widget.elements));
      };
    }
    return InkWell(
      child: Icon(Icons.arrow_back_ios_rounded, size: 40, color: color,),
      onTap: cb,
    );
  }

  Widget forwardIconButton() {
    int idx = widget.idx;
    List<ListElement> elements = widget.elements;
    Color color = Colors.black12;
    GestureTapCallback cb = () {};

    if(idx - 1 >= 0 && elements.elementAt(idx-1).title != null) {
      color = Colors.black;
      cb = () {
        Navigator.pushReplacementNamed(context, ViewWidget.routeName,
            arguments: ViewArgs(widget.idx - 1, widget.elements));
      };
    }
    return InkWell(
      child: Icon(Icons.arrow_forward_ios_rounded, size: 40, color: color,),
      onTap: cb,
    );
  }
}

class ImageList extends StatelessWidget {
  final String path, title;

  ImageList(this.path, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<ViewModel>(
        future: fetchView(this.path, this.title),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: buildImage(snapshot),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return loading();
        },
      ),
    );
  }

  List<Widget> buildImage(snapshot) {
    List<Widget> elements = List<Widget>();

    for (final e in snapshot.data.elements) {
      if (e.path != null) {
        String path;
        path = makeFull(e.path);

        elements.add(Image.network(path, loadingBuilder: (BuildContext context,
            Widget child, ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Container(
              child: loading(),
              padding: EdgeInsets.symmetric(vertical: 100),
            );
          }
        }));
      }
    }

    return elements;
  }
}
