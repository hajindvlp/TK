import 'package:flutter/material.dart';

class TableTitle extends StatelessWidget {
  final String title;

  TableTitle(this.title);

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40;
    const TextStyle titleStyle = TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
    BoxDecoration titleDeco = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    );

    return Container(
      decoration: titleDeco,
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: titleStyle),
          Spacer(),
          InkWell(
            child: Center(child: Icon(Icons.search, size: iconSize)),
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          SizedBox(width: 10),
          Center(
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.arrow_forward_ios, size: iconSize),
            ),
          ),
        ],
      ),
    );
  }
}
