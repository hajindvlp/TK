import 'package:flutter/material.dart';
import '../models/view.dart';

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

  Widget buildTitle() {
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
        if (e.path.startsWith("http")) {
          elements.add(Image.network("${e.path}"));
        } else {
          elements.add(Image.network(makeFull(e.path)));
        }
      }
    }

    return elements;
  }

  Widget buildImages() {
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

              return Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator());
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(child: buildTitle()),
        Expanded(child: buildImages())
      ],
    ));
  }
}
