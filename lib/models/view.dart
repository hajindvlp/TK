import 'dart:async';
import 'package:html/parser.dart';
import 'package:tk/models/list.dart';
import '../utils/fetchGet.dart';
import 'dart:convert';
import 'model.dart';

class ViewArgs {
  List<ListElement> elements;
  int idx;
  ViewArgs(this.idx, this.elements);
}

class ViewModel extends ContainerModel<ViewElement> {
  ViewModel({path, title, elements})
      : super(path: path, title: title, elements: elements);

  factory ViewModel.fromHtml(String path, String title, String html) {
    // The images are post-generated by javascript
    // need to parse javascript and get base64 encoded code

    var scriptIdx = html.indexOf("var toon_img = '");
    String scriptStart = html.substring(scriptIdx).split("var toon_img = '")[1];
    var scriptEndIdx = scriptStart.indexOf("';");
    String encodedImg = scriptStart.substring(0, scriptEndIdx);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decodedImg = stringToBase64.decode(encodedImg);

    var document = parse(decodedImg);

    var elements = document
        .getElementsByTagName("img")
        .map((imgTag) => ViewElement(imgTag.attributes['src']))
        .toList();

    return ViewModel(path: path, title: title, elements: elements);
  }
}

class ViewElement extends BasicModel {
  ViewElement(path) : super(path: path);
}

Future<ViewModel> fetchView(String path, String title) async {
  final response = await fetchGet(path);

  if (response.statusCode == 200) {
    return ViewModel.fromHtml(path, title, response.body);
  } else {
    return ViewModel(path: path, title: "404", elements: []);
  }
}
