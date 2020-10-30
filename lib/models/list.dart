import 'dart:async';
import 'package:html/parser.dart';
import '../utils/fetchGet.dart';
import 'model.dart';

class ListArgs extends BasicModel {
  ListArgs(path, title) : super(path: path, title: title);
}

class ListModel extends ContainerModel<ListElement> {
  ListModel({path, title, elements})
      : super(path: path, title: title, elements: elements);

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

class ListElement extends BasicModel {
  ListElement(path, title) : super(path: path, title: title);
}

Future<ListModel> fetchList(String path, String title) async {
  final response = await fetchGet(path);

  if (response.statusCode == 200) {
    return ListModel.fromHTML(path, title, response.body);
  } else {
    return ListModel(path: path, title: "404", elements: []);
  }
}
