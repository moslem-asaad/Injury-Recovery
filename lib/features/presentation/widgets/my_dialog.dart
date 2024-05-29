import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({Key? key}) : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late List<TextEditingController> _controllers;
  int _fieldCount = 1;

  @override
  void initState() {
    super.initState();
    _controllers = [TextEditingController()];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Videos IDs'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display existing text fields
          for (int i = 0; i < _fieldCount; i++)
            TextField(
              controller: _controllers[i],
              onChanged: (value) {
                // Update the value in the list as the user types
                // You can access it using _controllers[i].text
                
              },
              decoration: InputDecoration(
                hintText: 'Video ${i + 1} ID',
              ),
            ),
          // Add button to create new text fields
          ElevatedButton(
            onPressed: _addField,
            child: const Text('Add'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_controllers[0]);
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  // Function to add new text fields
  void _addField() {
    setState(() {
      _fieldCount++;
      _controllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    // Dispose all controllers when the dialog is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
