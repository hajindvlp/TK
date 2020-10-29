import 'package:http/http.dart' as http;

Future<http.Response> fetchGet(String path) {
  const ENDPOINT = "https://tkor.pw";
  return http.get('${ENDPOINT}${path}');
}
