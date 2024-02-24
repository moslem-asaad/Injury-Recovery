import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

class UploadVideoView extends StatefulWidget {
  const UploadVideoView({super.key});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
  UploadTask? task;
  File? file;

  @override
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
  }

  uploadFile(File? file) async{
    if(file == null) null;
    final fileName = getFileName(file);
    final destination = 'files/$fileName';
    try{
      task = AuthService.firebase().uploadFile(destination, file!);
      setState(() {});
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print(urlDownload);

    }catch(e){
      showErrorDialog(context, 'Error On Uploading the File');
    }
  }

  String getFileName(File? file){
    if(file!=null) return file!.path.split('/').last;
    else return 'No File Selected';
  }

  showUploadProgress(UploadTask task)=> StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents, 
    builder: (context, snapshot) {
      if(snapshot.hasData){
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred/snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);
        return Text(
          '$percentage %',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        );
      }else{
        return Container();
      }
    }, 
  );
}