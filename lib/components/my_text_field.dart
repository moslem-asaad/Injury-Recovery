import 'package:flutter/material.dart';
import 'package:injury_recovery/constants/colors.dart' as co;

class MyTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? readOnly;
  final Color? fillcolor;
  
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText, 
    required this.obscureText,
    required this.enableSuggestions,
    required this.autocorrect,
    this.keyboardType,
    required this.maxLines,
    this.readOnly = false,
    this.fillcolor = const Color.fromARGB(255, 238, 238, 238),
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly!,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: fillcolor,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}