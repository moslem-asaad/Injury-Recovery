import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: MenuButton(title: 'Main UI').bar(context),
      body: Column(
        children: [
          const SizedBox(height: 150),
          MyButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(uploadVideoRout);
              },
              title: 'upload video'),
          MyButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(gallaryRout);
              },
              title: 'Gallary'),
          MyButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(createTreatmentRoute);
              },
              title: 'Create Treatment'),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blue,
        title: const Text(
          'Sign Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
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
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
