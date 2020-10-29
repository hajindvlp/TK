import 'dart:async';
import 'package:html/parser.dart';
import '../utils/fetchGet.dart';

class ListArgs {
  final String path;
  final String title;

  ListArgs(this.path, this.title);
}

class ListModel {
  String path;
  String title;
  List<ListElement> elements;

  ListModel({this.path, this.title, this.elements});

  factory ListModel.fromHTML(String path, String title, String html) {
    var document = parse(html);

    var elements = document
        .getElementsByClassName('content__title')
        .map((td) =>
            ListElement(td.attributes['data-role'], td.attributes['alt']))
        .toList();

    return ListModel(path: path, title: title, elements: elements);
  }
}

class ListElement {
  String path;
  String title;

  ListElement(this.path, this.title);
}

Future<ListModel> fetchList(String path, String title) async {
  final response = await fetchGet(path);

  if (response.statusCode == 200) {
    return ListModel.fromHTML(path, title, response.body);
  } else {
    return ListModel(path: path, title: "404", elements: []);
  }
}
