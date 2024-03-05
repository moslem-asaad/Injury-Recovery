import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class LandScapeView extends StatefulWidget {
  const LandScapeView({super.key, required this.controller});
  final VideoPlayerController? controller;

  @override
  State<LandScapeView> createState() => _LandScapeViewState();
}

class _LandScapeViewState extends State<LandScapeView> {

  Future _landscapeMode() async{
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future _setAllOrientation() async{
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void initState() {
    super.initState();
    _landscapeMode();
  }

  @override
  void dispose() {
    _setAllOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(widget.controller!);
  }
}