import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/routes.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const MenuButton(title: 'my profile').bar(context),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                'Welcome Valued Client ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          MyButton(
              onPressed: () => {
                    Navigator.of(context).pushNamed(
                      treatmentsRout,
                    ),
                  },
              title: 'Treatments'),
          SizedBox(
            height: screen_height / 32.5,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    height: screen_height / 4,
                    width: screen_width,
                    child: Column(
                      children: [
                        Text(
                          'Current Treatment',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'watch sequential treatment videos',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: screen_height / 8,
                        ),
                        /*call a function that calculate the progress (numofvideos/numpfvideos watched)*/ Text(
                            '%'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screen_height / 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    children: [
                      MyButton(onPressed: () {}, title: 'progress report'),
                      MyButton(onPressed: () {}, title: 'performance report'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
