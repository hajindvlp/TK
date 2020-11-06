import 'package:flutter/material.dart';

import 'package:tk/components/list.dart';
import 'package:tk/models/list.dart';

class IntroCard extends StatelessWidget {
  final String imgSrc;
  final String title;
  final String summary;
  final String path;
  static const TextStyle titleStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  IntroCard({
    @required this.imgSrc,
    @required this.title,
    @required this.path,
    @required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () => _onCardTap(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imgSrc),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              alignment: Alignment.center,
              child: Text(
                title,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCardTap(BuildContext context) {
    Navigator.pushNamed(
      context,
      ListWidget.routeName,
      arguments: ListArgs(path, title),
    );
  }
}
