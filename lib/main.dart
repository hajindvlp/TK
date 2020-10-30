import 'package:flutter/material.dart';

import 'components/table.dart';
import 'components/list.dart';
import 'components/view.dart';

import 'models/list.dart';
import 'models/view.dart';

void main() => runApp(MyApp());

// TODO : add theme (light & dark theme)

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == ListWidget.routeName) {
          final ListArgs args = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return SafeArea(
              child: ListWidget(args.path, args.title, key: UniqueKey()),
            );
          });
        } else if (settings.name == ViewWidget.routeName) {
          final ViewArgs args = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return SafeArea(
              child: ViewWidget(args.path, args.title, key: UniqueKey()),
            );
          });
        } else {
          // TODO : 404 page
          return MaterialPageRoute(builder: (context) {
            return SafeArea(child: TableList());
          });
        }
      },
      title: "tk App",
      initialRoute: '/',
      routes: {
        '/': (context) => SafeArea(child: TableList()),
      },
    );
  }
}
