import 'package:flutter/material.dart';

List<BoxShadow>? myBoxShadow({Color color = Colors.grey}) {
  return [
    BoxShadow(
      color: color.withOpacity(0.7),
      spreadRadius: 7,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ];
}
