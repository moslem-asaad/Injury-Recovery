import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/all_feedbacks.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
import 'package:injury_recovery/features/presentation/widgets/my_box_shadow.dart';
import 'package:injury_recovery/features/presentation/widgets/my_container_button.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

import '../../widgets/treatments_images.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  late String name = ' ';

  @override
  void initState() {
    setState(() {
      setName();
    });
    super.initState();
  }

  Future<String> _getUserName() async {
    var firstName = await Service().getUserFirstName();
    if (firstName.errorOccured!) {
      await showErrorDialog(context, firstName.errorMessage!);
    }
    var lastName = await Service().getUserLastName();
    if (lastName.errorOccured!) {
      await showErrorDialog(context, lastName.errorMessage!);
    }

    return '${firstName.val} ${lastName.val}';
  }

  void setName() async {
    name = await _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const MenuButton(title: 'הפרופיל שלי').bar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //getLogo(context, 0.15),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  'ברוך הבא ',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.account_circle,
              size: screen_width * 0.2,
              color: Color.fromARGB(255, 157, 72, 66),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _myResquests(context),
                _myTreatments(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _myResquests(BuildContext context) {
    return MyContainerButton(
      context,
      my_blue,
      () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AllUserFeedbacks(),
        ));
      },
      'הבקשות שלי',
      getQuesionalizingimage(context, 0.12, 1),
    );
  }

  Widget _myTreatments(BuildContext context) {
    return MyContainerButton(
      context,
      my_green,
      () {
        Navigator.of(context).pushNamed(
          treatmentsRout,
        );
      },
      'הטיפולים שלי',
      getTherapyIcon(context, 0.12, 1, 't3'),
    );
  }
}
