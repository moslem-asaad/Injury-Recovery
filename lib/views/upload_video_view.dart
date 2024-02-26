import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/services/store/store_date.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:video_player/video_player.dart';

class UploadVideoView extends StatefulWidget {
  const UploadVideoView({super.key});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
  UploadTask? task;
  File? file;
  String? _videoURL;
  VideoPlayerController? _controller;
  String? _downloadURL;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Center(
            child: _videoURL != null
                ? _videoPlayerPreview()
                : const Text('No Video is Selected'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        child: const Icon(Icons.video_library),
      ),
    );
  }

  void _pickVideo() async {
    final picker = ImagePicker();
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      _videoURL = videoFile!.path;
    } catch (e) {
      print(e.toString());
    }
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoURL!))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  Widget _videoPlayerPreview() {
    if (_controller != null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          ElevatedButton(
            onPressed: _uploadVideo, 
            child: const Text('Upload'),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  void _uploadVideo() async{
    _downloadURL = await StoreData().uploadVideo(_videoURL!);
    await StoreData().saveVideoData(_downloadURL!);
    setState(() {
      _videoURL = null;
    });
  }
  /*@override
  Widget build(BuildContext context) {
    final String filename = getFileName(file);
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            MyButton(
              onPressed: () async{
                final result = await FilePicker.platform.pickFiles(allowMultiple: false);
                if(result == null) return;
                final path = result.files.single.path;
                setState(() {
                  file = File(path!);
                });
              }, 
              title: 'Select File',
            ),
            Text(
              filename,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),
            MyButton(
              onPressed: ()async{
                uploadFile(file);
            }, 
              title: 'Upload File'
            ),
            task!=null? showUploadProgress(task!): Container(),
          ],
        ),
      ),
    );
  }*/

  uploadFile(File? file) async {
    if (file == null) null;
    final fileName = getFileName(file);
    final destination = 'files/$fileName';
    try {
      task = AuthService.firebase().uploadFile(destination, file!);
      setState(() {});
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print(urlDownload);
    } catch (e) {
      showErrorDialog(context, 'Error On Uploading the File');
    }
  }

  String getFileName(File? file) {
    if (file != null)
      return file!.path.split('/').last;
    else
      return 'No File Selected';
  }

  showUploadProgress(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);
        return Text(
          '$percentage %',
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        );
      } else {
        return Container();
      }
    },
  );
}
