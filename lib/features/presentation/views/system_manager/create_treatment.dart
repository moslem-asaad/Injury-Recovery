import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/exercise_videos.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

class CreateTreatments extends StatefulWidget {
  const CreateTreatments({super.key});

  @override
  State<CreateTreatments> createState() => _CreateTreatmentsViewState();
}

class _CreateTreatmentsViewState extends State<CreateTreatments> {
  late final TextEditingController _treatment_name;
  late final TextEditingController _user_name;
  //late final TextEditingController _video_url;
  late final TextEditingController _treatment_discription;
  late List<int> videos;
  int videosLength = 0;

  void initState() {
    _treatment_name = TextEditingController();
    _user_name = TextEditingController();
    //_video_url = TextEditingController();
    _treatment_discription = TextEditingController();
    videos = [];
    super.initState();
  }

  @override
  void dispose() {
    _treatment_name.dispose();
    _user_name.dispose();
    //_video_url.dispose();
    _treatment_discription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgraound,
      appBar: AppBar(
        title: const Center(child: Text('Create Treatment')),
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyTextField(
                  controller: _treatment_name,
                  hintText: 'Treatment Name',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  maxLines: null,
                ),
                SizedBox(height: screen_height / 82),
                MyTextField(
                  controller: _user_name,
                  hintText: 'User Name',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  maxLines: null,
                ),
                SizedBox(height: screen_height / 82),
                /*MyTextField(
            controller: _video_url,
            hintText: 'Video URL',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.url,
            maxLines: null,
          ),
          SizedBox(height: screen_height / 82),*/
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          videos = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => ExerciseVideos(),
                          )); //videos = (await _getVideosIds());
                          setState(() {
                            num_videos();
                          });
                        },
                        child: Text('pick treatment videos'),
                      ),
                    ),
                    Visibility(
                      child: Text(
                        '${num_videos()} סרטונים נבחרו',
                      ),
                      visible: videos.isNotEmpty,
                    ),
                  ],
                ),
                SizedBox(height: screen_height / 82),
                MyTextField(
                  controller: _treatment_discription,
                  hintText: 'Treatment Discription',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                ),
                MyButton(
                  onPressed: () async {
                    var response = await Service().createTreatment(
                        _user_name.text, _treatment_discription.text, videos);

                    if (response.errorOccured!) {
                      await showErrorDialog(context, response.errorMessage!);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  title: 'Crerate Treatment',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int num_videos(){
    setState(() {
      videosLength = videos.length;
    });
    return videosLength;
  }

  Future<List<int>> _getVideosIds() async {
    int _fieldCount = 1;
    List<int> videos = [];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Videos IDs'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display existing text fields
                  for (int i = 0; i < _fieldCount; i++)
                    TextField(
                      onChanged: (value) {
                        // Update the value in the list as the user types
                        // You can access it using _controllers[i].text
                        videos.add(int.tryParse(value)!);
                      },
                      decoration: InputDecoration(
                        hintText: 'Video ${i + 1} ID',
                      ),
                    ),
                  // Add button to create new text fields
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _fieldCount++;
                      });
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    return videos;
  }

  void _addField(int _fieldCount) {
    setState(() {
      _fieldCount++;
    });
  }
}
