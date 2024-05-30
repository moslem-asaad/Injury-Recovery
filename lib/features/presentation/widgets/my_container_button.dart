import 'package:flutter/material.dart';
import 'package:injury_recovery/features/presentation/widgets/my_box_shadow.dart';

import '../../../constants/colors.dart';

Widget MyContainerButton(BuildContext context, Color color,
      void Function()? onPressed, String buttenName, ClipRRect icon) {
    double screen_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screen_width * 0.4,
        height: screen_width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          boxShadow: myBoxShadow(),
          color: color,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Column(
            children: [
              Text(
                buttenName,
                style: TextStyle(
                    fontSize: screen_width * 0.05, color: backgraound),
              ),
              const SizedBox(
                height: 5,
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }