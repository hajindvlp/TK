import 'package:http/http.dart' as http;

Future<http.Response> fetchGet(String path) {
  return http.get(makeFull(path));
}

String makeFull(String path) {
  if (path.startsWith("https")) {
    return path;
  } else {
    return "https://tkor.pw${path}";
  }
}
