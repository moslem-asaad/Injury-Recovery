import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/components/menu_button.dart';
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
      appBar: const MenuButton(title: 'Gallary').bar(context),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Border color
              borderRadius: BorderRadius.circular(
                  20), // Adjust border radius as needed for rounded corners
              color: Colors.grey[200], // Adjust background color as needed
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/ball_cure.png',
                    width: 200,
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('videos')
                      .orderBy('id')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> videoWidgets = [];
                    if (!snapshot.hasData) {
                      const CircularProgressIndicator();
                    } else {
                      final videos = snapshot.data?.docs.toList();
                      for (var video in videos!) {
                        final videoWidget = Padding(
                          padding: const EdgeInsets.all(19.0),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors
                                  .grey[300],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${video['id']}- ${video['name']}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey),
                                      borderRadius: BorderRadius.circular(
                                          15), 
                                      color: Colors.grey[200]),
                                      height: 40,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return PlayVideoView(
                                              videoName: video['name'],
                                              videoURL: video['url'],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.black,
                                    ),
                                    label: const Text(
                                      'Play Video',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
