import 'package:flutter/material.dart';

Widget loading() {
  return Center(
    child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        child: CircularProgressIndicator()),
  );
}
