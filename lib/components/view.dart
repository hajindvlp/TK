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
  Future<ViewModel> futureViewModel;

  @override
  void initState() {
    super.initState();
    futureViewModel = fetchView(widget.path, widget.title);
  }

  @override
  void didUpdateWidget(ViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      this.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(child: _renderTitle()),
        Expanded(child: _renderImages())
      ],
    ));
  }

  Widget _renderTitle() {
    const titleTextStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
    return Container(
        child: Text(
      widget.title,
      style: titleTextStyle,
      overflow: TextOverflow.ellipsis,
    ));
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

  Widget _renderImages() {
    return Container(
        child: FutureBuilder<ViewModel>(
            future: futureViewModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: buildImage(snapshot),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return loading();
            }));
  }
}
