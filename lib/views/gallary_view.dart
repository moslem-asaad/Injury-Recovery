import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injury_recovery/views/play_video_view.dart';

class GallaryView extends StatefulWidget {
  const GallaryView({super.key});

  @override
  State<GallaryView> createState() => _GallaryViewState();
}

class _GallaryViewState extends State<GallaryView> {
  late Future<ListResult> _files;

  @override
  void initState() {
    super.initState();
    _files = FirebaseStorage.instance.ref('/videos').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallary'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('videos').snapshots(),
                builder: (context, snapshot) {
                  List<Row> videoWidgets = [];
                  if (!snapshot.hasData) {
                    const CircularProgressIndicator();
                  } else {
                    final videos = snapshot.data?.docs.reversed.toList();
                    for (var video in videos!) {
                      final videoWidget = Row(
                        children: [
                          Text(
                            video['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_){
                                  return PlayVideoView(videoName: video['name'], videoURL: video['url'],);
                                },),
                              );
                            }, 
                            icon: Icon(Icons.play_arrow_rounded,color: Colors.white,),
                          ),
                        ],
                      );
                      videoWidgets.add(videoWidget);
                    }
                  }
                  return Expanded(
                      child: ListView(
                    children: videoWidgets,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder getFiles() {
    return FutureBuilder<ListResult>(
      future: _files,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final files = snapshot.data!.items;
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                title: Text(
                  file.name,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Error Occured While Viewing The Files'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
