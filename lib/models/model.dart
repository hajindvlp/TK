abstract class ElementModel {}

class ContainerModel<T> extends BasicModel {
  List<T> elements;

  ContainerModel({path, title, this.elements})
      : super(path: path, title: title);
}

class BasicModel {
  String title;
  String path;

  BasicModel({this.path, this.title});
}
