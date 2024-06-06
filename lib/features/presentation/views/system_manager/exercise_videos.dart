import 'package:flutter/material.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/presentation/widgets/Loading_page.dart';
import 'package:video_player/video_player.dart';

import '../../../../components/menu_button.dart';
import '../../../../utilities/show_error_dialog.dart';
import '../../services/service_layer.dart';
import '../../widgets/my_video_player.dart';

class ExerciseVideos extends StatefulWidget {
  const ExerciseVideos({super.key});

  @override
  State<ExerciseVideos> createState() => _ExerciseVideosState();
}

class _ExerciseVideosState extends State<ExerciseVideos> {
  late Future<List<ExerciseVideo>> futureVideos;
  final Map<String, VideoPlayerController> _controllers = {};
  final Map<String, Color> videosColors = {};
  late List<int> selectedVideos = [];
  @override
  void initState() {
    super.initState();
    futureVideos = _getvideos();
  }

  Future<List<ExerciseVideo>> _getvideos() async {
    var exerciseVideoResponse = await Service().getAllExerciseVideos();
    if (exerciseVideoResponse.errorOccured!) {
      await showErrorDialog(context, exerciseVideoResponse.errorMessage!);
      return [];
    } else {
      return exerciseVideoResponse.val!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureVideos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(context);
        } else if (snapshot.hasError) {
          showErrorDialog(context, '${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          var videos = snapshot.data!;
          for (var video in videos) {
            _getVideoPlayerController(video.videoUrl!);
          }
          return Scaffold(
            backgroundColor: backgraound,
            appBar: MenuButton(title: 'תבחר את הסירטונים').bar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (var video in videos) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _videoWidget(video),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, selectedVideos);
                    },
                    icon: Icon(Icons.check),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _videoWidget(ExerciseVideo video) {
    return ElevatedButton(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: MyVideoPlayer(
          controller: _getVideoPlayerController(video.videoUrl!),
        ),
      ),
      onPressed: () {
        setVidoColor(video.videoUrl!);
        if (selectedVideos.contains(video.videoGlobalId)) {
          selectedVideos.remove(video.videoGlobalId);
        } else {
          selectedVideos.add(video.videoGlobalId!);
        }
        // _getVideoPlayerController(video.videoUrl!).dispose();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          videosColors[video.videoUrl!],
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Adjust the border radius as needed
            side: BorderSide(
                color: Colors.black), // Adjust the border color as needed
          ),
        ),
      ),
    );
  }

  disposeControllers() {
    _controllers.values.forEach((controller) => controller.dispose());
  }

  _getVideoPlayerController(String videoUrl) {
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
      videosColors[videoUrl] = backgraound;
    }
  }

  setVidoColor(String videoUrl) {
    setState(() {
      if (videosColors[videoUrl] == my_green) {
        videosColors[videoUrl] = backgraound;
      } else
        videosColors[videoUrl] = my_green;
    });
  }
}
