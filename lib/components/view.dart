import 'package:flutter/material.dart';
import '../models/view.dart';
import '../utils/fetchGet.dart';
import 'common.dart';

class ViewWidget extends StatefulWidget {
  static const String routeName = "/view";
  final String path;
  final String title;

  ViewWidget(this.path, this.title, {Key key}) : super(key: key);

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
    return () {setState(() {_showControl = !_showControl; });};
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> controls =
        (_showControl) ? [_renderTopControl(), _renderBottomControl()] : [];

    return Scaffold(
          body: Stack(
            children: [
              InkWell(
                onTap: toggleShowControl(),
                child : ListView(children: [ImageList(widget.path, widget.title),]),
              ),
              ...controls,
            ],
          ),
        );
  }

  Widget _renderTopControl() {
    const titleTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    return Positioned(
      top: 0,
      child: Row(
          children: [
            Icon(Icons.arrow_back_ios, size: 24),
            Text(
              widget.title,
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
            Divider(thickness: 2,),
          ]),
    );
  }

  Widget _renderBottomControl() {
    const double iconSize = 20;
    return Positioned(
      bottom: 0,
      child: Row(
        children: [
          Divider(thickness: 2,),
          Icon(Icons.format_list_bulleted, size: iconSize),
          Icon(Icons.arrow_back_ios_rounded, size: iconSize),
          Icon(Icons.arrow_forward_ios_rounded, size: iconSize),
        ],
      ),
    );
  }
}

class ImageList extends StatelessWidget {
  String path, title;
  ImageList(this.path, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(child: FutureBuilder<ViewModel>(
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
    ),);
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
