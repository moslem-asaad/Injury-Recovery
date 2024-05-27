import 'package:flutter/material.dart';

getImage(BuildContext context,double ratio,int index) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.asset(
      'images/$index.jpg',
      width: MediaQuery.of(context).size.height * ratio,
    ),
  );
}

getthumpnail(BuildContext context,double ratio,int index) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.asset(
      'images/feedback_image$index.jpg',
      width: MediaQuery.of(context).size.height * ratio,
    ),
  );
}