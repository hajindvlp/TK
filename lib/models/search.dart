import 'dart:async';
import 'package:html/parser.dart';
import '../utils/fetchGet.dart';
import 'model.dart';

class SearchModel extends ContainerModel<SearchElement> {
  SearchModel({path, title, elements})
      : super(path: path, title: title, elements: elements);

  factory SearchModel.fromHTML(String path, String html) {
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

    var elements = List<SearchElement>();

    for (var i = 0; i < titles.length; i++) {
      elements.add(SearchElement(urls[i], titles[i], imageSrcs[i], intros[i]));
    }
    return SearchModel(
        path: path, title: path.split('/')[1], elements: elements);
  }
}

class SearchElement extends BasicModel {
  String thumbnail;
  String intro;

  SearchElement(path, title, this.thumbnail, this.intro)
      : super(path: path, title: title);
}

Future<SearchModel> fetchResult(String path) async {
  final response = await fetchGet(path);

  if (response.statusCode == 200) {
    return SearchModel.fromHTML(path, response.body);
  } else {
    return SearchModel(path: path, title: "404", elements: []);
  }
}
