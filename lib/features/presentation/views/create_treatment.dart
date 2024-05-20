import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/routes.dart';

class CreateTreatments extends StatefulWidget {
  const CreateTreatments({super.key});

  @override
  State<CreateTreatments> createState() => _CreateTreatmentsViewState();
}

class _CreateTreatmentsViewState extends State<CreateTreatments> {
  late final TextEditingController _treatment_name;
  late final TextEditingController _user_name;
  late final TextEditingController _video_url;
  late final TextEditingController _treatment_discription;

  void initState() {
    _treatment_name = TextEditingController();
    _user_name = TextEditingController();
    _video_url = TextEditingController();
    _treatment_discription = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _treatment_name.dispose();
    _user_name.dispose();
    _video_url.dispose();
    _treatment_discription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Center(child: Text('Create Treatment')),
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey,
        ),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(children: [
          MyTextField(
            controller: _treatment_name,
            hintText: 'Treatment Name',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: screen_height / 82),
          MyTextField(
            controller: _user_name,
            hintText: 'User Name',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: screen_height / 82),
          MyTextField(
            controller: _video_url,
            hintText: 'Video URL',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.url,
          ),
          SizedBox(height: screen_height / 82),
          MyTextField(
            controller: _treatment_discription,
            hintText: 'Treatment Discription',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
          ),
          MyButton(
            onPressed: () async {
              Scaffold();
            },
            title: 'Crerate Treatment',
          ),
        ])))));
  }
}
