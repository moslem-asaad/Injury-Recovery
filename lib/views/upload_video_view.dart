import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

class UploadVideoView extends StatefulWidget {
  const UploadVideoView({super.key});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {

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
            const SizedBox(height: 25),
            MyButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, 
              title: 'Restart'
            ),

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
                if(file == null) null;
                final fileName = getFileName(file);
                final destination = 'files/$fileName';
                try{
                  final ref = FirebaseStorage.instance.ref(destination);
                  return ref.putFile(file!);
                }catch(e){

                }
            }, 
              title: 'Upload File'),
          ],
        ),
      ),
    );
  }

  String getFileName(File? file){
    if(file!=null) return file!.path.split('/').last;
    else return 'No File Selected';
  }
}