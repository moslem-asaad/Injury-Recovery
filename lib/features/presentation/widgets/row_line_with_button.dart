import 'package:flutter/material.dart';
import 'package:injury_recovery/constants/colors.dart';

class RowTextTextButtun extends StatefulWidget {
  final String text1;
  final void Function()? onPresses;
  final String button_text;
  const RowTextTextButtun({super.key,required this.text1,required this.onPresses, required this.button_text});

  @override
  State<RowTextTextButtun> createState() => _RowTextTextButtunState();
}

class _RowTextTextButtunState extends State<RowTextTextButtun> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.text1,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: widget.onPresses,
          child: Text(
            widget.button_text,
            style: const TextStyle(
              color: my_green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
