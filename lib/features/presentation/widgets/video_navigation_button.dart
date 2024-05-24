import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../domain/entities/exercise_video.dart';

class VideoNavigationButtons extends StatefulWidget {
  final List<ExerciseVideo> videos;
  final int currentIndex;
  final Function(int,int) onPageChanged;

  const VideoNavigationButtons({
    Key? key,
    required this.videos,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  _VideoNavigationButtonsState createState() => _VideoNavigationButtonsState();
}

class _VideoNavigationButtonsState extends State<VideoNavigationButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.videos.length,
        (index) => GestureDetector(
          onTap: () {
            widget.onPageChanged(index,20);
          },
          child: Column(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: index == widget.currentIndex
                      ? Colors.blue
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*class VideoNavigationButtons extends StatelessWidget {
  final Treatment treatment;
  final int selectedIndex;
  final void Function(int) onVideoSelected;

  const VideoNavigationButtons({
    Key? key,
    required this.treatment,
    required this.selectedIndex,
    required this.onVideoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        treatment.videosList.length,
        (index) => GestureDetector(
          onTap: () {
            onVideoSelected(index);
          },
          child: Column(
            children: [
              Container(
                width: 20, // Adjust the width of the circle
                height: 20, // Adjust the height of the circle
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: selectedIndex == index ? Colors.blue : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/