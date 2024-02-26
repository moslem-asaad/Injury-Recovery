import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

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
    _files = FirebaseStorage.instance.ref('/files').listAll();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallary'),
      ),
      body: FutureBuilder<ListResult>(
        future: _files,
        builder:(context, snapshot) {
          if(snapshot.hasData){
            final files = snapshot.data!.items;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index){
                final file = files[index];
                return ListTile(
                  title: Text(
                    file.name,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
                );
              },
            );
          }
          else if (snapshot.hasError){
            return const Center(child: Text('Error Occured While Viewing The Files'));
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}