import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/features/presentation/widgets/my_container_button.dart';
import 'package:injury_recovery/features/presentation/widgets/treatments_images.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgraound,
      appBar: MenuButton(title: 'הפרופיל שלי').bar(context),
      body: Column(
        children: [
          //const SizedBox(height: 150),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _uploadVideo(context),
              ),
              _createTreatment(context),
            ],
          ),
          
          Row(
            children: [
              _userFeedbacks(context),
            ],
          ),
          /*MyButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(uploadVideoRout);
              },
              title: 'upload video'),
          MyButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(createTreatmentRoute);
              },
              title: 'Create Treatment'),
          MyButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(usersFeedbacksRout);
              },
              title: 'Users Feedbacks'),*/
        ],
      ),
    );
  }
}

Widget _uploadVideo(BuildContext context) {
  return MyContainerButton(
    context,
    my_green,
    () {
      Navigator.of(context).pushNamed(uploadVideoRout);
    },
    'העלאת סרטון ',
    getToMainUI(context, 0.1, 1),
  );
}

Widget _createTreatment(BuildContext context) {
  return MyContainerButton(
    context,
    my_green,
    () {
      Navigator.of(context).pushNamed(createTreatmentRoute);
    },
    'יצירת טיפול ',
    getToMainUI(context, 0.1, 2),
  );
}

Widget _userFeedbacks(BuildContext context) {
  return Expanded(
    child: MyContainerButton(
      context,
      my_blue,
      () {
        Navigator.of(context).pushNamed(usersFeedbacksRout);
      },
      'תגובות משתמשים ',
      getToMainUI(context, 0.1, 3),
    ),
  );
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blue,
        title: const Text(
          'התנתק',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'האם אתה בטוח שאתה רוצה לצאת?',
          style: TextStyle(
            fontSize: Checkbox.width,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(35, 0, 0, 0),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(35, 0, 0, 0),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('התנתק'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
