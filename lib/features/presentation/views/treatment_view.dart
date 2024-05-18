import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/constants/colors.dart' as co;
import 'package:injury_recovery/features/presentation/views/videos_view.dart';
import 'package:injury_recovery/features/presentation/widgets/video_navigation_button.dart';
import 'package:video_player/video_player.dart';

import '../../../components/video_player_preview.dart';
import '../../domain/entities/exercise_video.dart';
import '../../domain/entities/treatment.dart';

class TreatmentView extends StatefulWidget {
  TreatmentView({super.key, required this.treatment, required this.index});
  final Treatment treatment;
  int index;

  @override
  State<TreatmentView> createState() => _TreatmentViewState();
}

class _TreatmentViewState extends State<TreatmentView> {
  late Treatment treatment;
  late String currentVideoUrl;
  VideoPlayerController? _controller;

  @override
  void dispose() {
    //_controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    treatment = widget.treatment;
    currentVideoUrl = treatment.videosList[widget.index].videoUrl;
    /*_controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videosList[0].videoUrl));
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    _controller!.play();*/
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: co.backgraound,
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              child: Text(
                'Videos',
                style: TextStyle(
                  color: co.text_color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Feedback Request',
                style: TextStyle(
                  color: co.text_color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
          title: Text('Treatment A'),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width,
                      maxHeight: height,
                    ),
                    child: Center(
                      child: VideosView(
                        videos: treatment.videosList,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
