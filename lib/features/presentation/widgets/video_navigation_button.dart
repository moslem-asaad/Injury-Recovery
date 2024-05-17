import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/presentation/views/treatment_view.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

import '../../../components/video_player_preview.dart';
import '../../domain/entities/exercise_video.dart';

class VideoNavigationButtons extends StatelessWidget {
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
}