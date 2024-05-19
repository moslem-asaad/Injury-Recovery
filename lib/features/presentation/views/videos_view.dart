import 'package:flutter/material.dart';
import 'package:injury_recovery/components/video_player_preview.dart';

import '../../domain/entities/exercise_video.dart';
import '../widgets/video_navigation_button.dart';

class VideosView extends StatefulWidget {
  const VideosView({
    Key? key,
    required this.videos,
  }) : super(key: key);

  final List<ExerciseVideo> videos;

  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      // Swiped from right to left, move to next video
      if (_currentPageIndex < widget.videos.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    } else if (details.primaryVelocity! < 0) {
      // Swiped from left to right, move to previous video
      if (_currentPageIndex > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

 @override
Widget build(BuildContext context) {
  return GestureDetector(
    onHorizontalDragEnd: _onHorizontalDragEnd,
    child: Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.videos.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return VideoPlayerPreview(
              videoURL: widget.videos[index].videoUrl,
            );
          },
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height*0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.green,
            height: MediaQuery.of(context).size.height * 0.57,
            //height: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoNavigationButtons(
                    videos: widget.videos,
                    currentIndex: _currentPageIndex,
                    onPageChanged: _onPageChanged,
                  ),
                  /*const SizedBox(
                    height: 50,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(widget.videos[_currentPageIndex].videoDescription),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
} 

}
