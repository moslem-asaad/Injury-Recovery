import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/feedback_request.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/video_player_preview.dart';
import 'package:injury_recovery/features/presentation/widgets/my_video_player.dart';
import 'package:video_player/video_player.dart';

import '../../../../domain/entities/exercise_video.dart';
import '../../../widgets/video_navigation_button.dart';

class VideosView extends StatefulWidget {
  const VideosView({
    Key? key,
    required this.videos,
    required this.treatmentId,
  }) : super(key: key);

  final List<ExerciseVideo> videos;
  final String treatmentId;

  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  // Map to store video player controllers for each video URL
  final Map<String, VideoPlayerController> _controllers = {};
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _controller =
        _getVideoPlayerController(widget.videos[_currentPageIndex].videoUrl);
  }

  // Method to retrieve or create video player controller for a given video URL
  VideoPlayerController _getVideoPlayerController(String videoUrl) {
    print('videoo $_currentPageIndex');
    if (_controllers.containsKey(videoUrl)) {
      // If controller already exists, return it
      return _controllers[videoUrl]!;
    } else {
      // If controller does not exist, create a new one and store it
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
      _controllers[videoUrl] = controller;
      return controller;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
      _controller = _getVideoPlayerController(widget.videos[index].videoUrl);
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged2(int index, int milliseconds) {
    setState(() {
      _currentPageIndex = index;
      _controller = _getVideoPlayerController(widget.videos[index].videoUrl);
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.ease,
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      // Swiped from left to right, move to previous video
      if (_currentPageIndex > 0) {
        _onPageChanged(_currentPageIndex - 1);
      }
    } else if (details.primaryVelocity! < 0) {
      // Swiped from right to left, move to next video
      if (_currentPageIndex < widget.videos.length - 1) {
        _onPageChanged(_currentPageIndex + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.videos.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            print('aaaaaa $index');
            /*return VideoPlayerPreview(
              videoURL: widget.videos[index].videoUrl,
              controller: _controller,
              onHorizontalDragEnd: _onHorizontalDragEnd,
            );*/
            _controller.play();
            _controller.setLooping(true);

            return MyVideoPlayer(
              controller: _controller,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              barButtons: ButtonBar(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        _controller.pause();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FeedbackRequest(
                            treatmentId: widget.treatmentId,
                            videoId: widget.videos[index].videoId,
                          ),
                        ));
                      },
                      child: Text('feedback')),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.green,
            height: MediaQuery.of(context).size.height * 0.57,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoNavigationButtons(
                    videos: widget.videos,
                    currentIndex: _currentPageIndex,
                    onPageChanged: _onPageChanged2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        Text(widget.videos[_currentPageIndex].videoDescription),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
