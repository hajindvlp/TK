import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/toon_table.dart';
import 'screens/toon_list.dart';
import 'screens/toon_view.dart';
import 'screens/mypage.dart';
import 'screens/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TK",
      initialRoute: '/',
      routes: {
        '/': (_) => Ho`me(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ToonList.routeName) {
          return MaterialPageRoute(
            builder: (_) => ToonList(settings.arguments),
          );
        } else if (settings.name == ToonView.routeName) {
          return MaterialPageRoute(
            builder: (_) => ToonView(settings.arguments),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => Home(),
          );
        }
      },
    );
  }
}
