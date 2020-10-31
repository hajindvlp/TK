import 'package:flutter/material.dart';
import 'package:tk/models/search.dart';

import 'list.dart';
import 'common.dart';
import '../models/list.dart';

class Search extends StatefulWidget {
  static const String routeName = "/search";
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  Future<SearchModel> futureSearchModel;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _query = "";
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _renderTopBar(),
          _renderResults(),
        ],
      ) ,
    );
  }

  Widget _renderTopBar() {
    const double iconSize = 40;
    BoxDecoration titleDeco = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    );

    return AnimatedContainer(
      decoration: titleDeco,
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      duration: Duration(seconds: 1),
      onEnd: () { Navigator.pushNamed(context, '/search'); },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: searchController,
              onFieldSubmitted: (String value) { _handleSearchTap(); },
            ),
          ),
          InkWell(
            child: Center(child: Icon(Icons.search, size: iconSize)),
            onTap: () { _handleSearchTap(); },
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  void _handleSearchTap() {
    setState(() {
      _query = searchController.text;
      futureSearchModel = fetchResult("/bbs/search.php?&stx=$_query");
    });
  }

  Widget _renderResults() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(1, 244, 244, 244)),
        child: _handleFuture(),
      ),
    );
  }

  FutureBuilder<SearchModel> _handleFuture() {
    return FutureBuilder<SearchModel>(
      future: futureSearchModel,
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
