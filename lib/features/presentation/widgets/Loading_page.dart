import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'treatments_images.dart';

Widget Loading(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: height * 0.2,
        ),
        Text('טוען..'),
        getGif(context, 1, 1, 'LoadingLogo'),
      ],
    ),
    color: backgraound,
  );
}
