
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance; 

class StoreData{
  Future<String> uploadVideo (String videoURL,Function(double)? onProgress) async{
    Reference ref = _storage.ref().child('/videos/${DateTime.now()}.mp4');
    UploadTask uploadTask = ref.putFile(File(videoURL));
    
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
    }, onError: (error) {
      // Handle upload error
      print('Error uploading video: $error');
    });
    await uploadTask;
    //await ref.putFile(File(videoURL));
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> saveVideoData(String videoDownloadURL,String videoName) async{
    await _firestore.collection('videos').add({
      'url': videoDownloadURL,
      'timeStamp': FieldValue.serverTimestamp(),
      'name': videoName,
    });
  }
}