import 'dart:async';
import 'package:html/parser.dart';
import '../utils/fetchGet.dart';

class TableModel {
  String path;
  String title;
  List<TableElement> elements;

  TableModel({this.path, this.title, this.elements});

  factory TableModel.fromHTML(String path, String html) {
    var document = parse(html);

    var urls = document
        .getElementsByClassName('toon-more')
        .map((aTag) => aTag.attributes['href'])
        .toList();
    var imageSrcs = document
        .getElementsByClassName('section-item-photo')
        .map((imageTag) =>
            imageTag.getElementsByTagName('img')[0].attributes['src'])
        .toList();
    var titles = urls.map((url) => url.split('/')[1]).toList();
    var intros = document
        .getElementsByClassName('toon-summary')
        .map((intro) => intro.innerHtml.trim())
        .toList();

    var elements = List<TableElement>();

    for (var i = 0; i < titles.length; i++) {
      elements.add(TableElement(urls[i], imageSrcs[i], titles[i], intros[i]));
    }
    return TableModel(
        path: path, title: path.split('/')[1], elements: elements);
  }
}

class TableElement {
  String path;
  String thumbnail;
  String title;
  String intro;

  TableElement(this.path, this.thumbnail, this.title, this.intro);
}

Future<TableModel> fetchTable(String path) async {
  final response = await fetchGet(path);

  if (response.statusCode == 200) {
    return TableModel.fromHTML(path, response.body);
  } else {
    return TableModel(path: path, title: "404", elements: []);
  }
}
