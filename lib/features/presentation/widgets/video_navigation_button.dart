import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

class VideoNavigationButtons extends StatefulWidget {
  final int numVideos;

  const VideoNavigationButtons({required this.numVideos});

  @override
  _VideoNavigationButtonsState createState() => _VideoNavigationButtonsState();
}

class _VideoNavigationButtonsState extends State<VideoNavigationButtons> {
  int selectedVideoIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.numVideos,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedVideoIndex = index;
            });
            // Navigate to specific video when circle is pressed
            // Add your navigation logic here
            showErrorDialog(context, 'index: $index');
          },
          child: Container(
            width: 20, // Adjust the width of the circle
            height: 20, // Adjust the height of the circle
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
              color: selectedVideoIndex == index ? Colors.blue : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
