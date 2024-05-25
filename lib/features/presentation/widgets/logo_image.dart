import 'package:flutter/material.dart';

getLogo(BuildContext context,double ratio) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.asset(
      'images/logo.png',
      width: MediaQuery.of(context).size.height * ratio,
    ),
  );
}
