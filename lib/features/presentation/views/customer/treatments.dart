import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/treatment_view.dart';
import 'package:injury_recovery/features/presentation/widgets/Loading_page.dart';
import 'package:injury_recovery/features/presentation/widgets/my_box_shadow.dart';
import 'package:injury_recovery/features/presentation/widgets/treatments_images.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import '../../../domain/entities/treatment.dart';

class Treatmants extends StatefulWidget {
  const Treatmants({super.key});

  @override
  State<Treatmants> createState() => _TreatmantsState();
}

class _TreatmantsState extends State<Treatmants> {
  late Future<List<Treatment>> futureTreatments;
  int image_index = 0;

  @override
  void initState() {
    super.initState();
    futureTreatments = _getUserTreatments();
  }

  Future<List<Treatment>> _getUserTreatments() async {
    var treatmentsResponse = await Service().getUserTreatments();
    if (treatmentsResponse.errorOccured!) {
      await showErrorDialog(context, treatmentsResponse.errorMessage!);
      return [];
    } else {
      return treatmentsResponse.val!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureTreatments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(context);
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else {
            var treatments = snapshot.data!;
            return Scaffold(
              appBar: const MenuButton(title: 'Treatments').bar(context),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var treatment in treatments)
                      treatmentWidget(treatment),
                  ],
                ),
              ),
            );
          }
        });
  }

  void increment_image_indx() {
    image_index = ((image_index + 1) % 5) + 1;
  }

  treatmentWidget(Treatment treatment) {
    increment_image_indx();
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
          boxShadow: myBoxShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getImage(context, 0.5, image_index),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    treatment.treatmentGlobalId!.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    'Duration: 30 mins',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                treatment.treatmentDescription!,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    start_treatment(context, treatment);
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: const Center(
                        child: Text(
                          'Start Treatment',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  start_treatment(BuildContext context, Treatment treatment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return TreatmentView(
            treatment: treatment,
            index: 0,
          );
        },
      ),
    );
  }
}
