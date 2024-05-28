
import 'package:flutter/material.dart';
import 'package:injury_recovery/constants/colors.dart' as co;

class MyButton extends StatelessWidget {

  final Function()? onPressed;
  final String title;

  const MyButton({super.key,required this.onPressed,required this.title});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: co.my_green,
          borderRadius: BorderRadius.circular(8),
          ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}