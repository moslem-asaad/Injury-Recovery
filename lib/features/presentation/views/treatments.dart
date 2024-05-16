import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/treatment_view.dart';

import '../../domain/entities/exercise_video.dart';
import '../../domain/entities/treatment.dart';

class Treatmants extends StatefulWidget {
  const Treatmants({super.key});

  @override
  State<Treatmants> createState() => _TreatmantsState();
}

class _TreatmantsState extends State<Treatmants> {
  late ResponseT<List<Treatment>> treatments;

  @override
  void initState() {
    super.initState();
    treatments = Service().getUserTreatments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuButton(title: 'Treatments').bar(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var treatment in treatments.val!)
              treatmentWidget(treatment.treatmentId,
                  treatment.treatmentDescription, treatment.videosList),
          ],
        ),
      ),
    );
  }

  treatmentWidget(String treatmentId, String treatmentDescription,
      List<ExerciseVideo> videosList) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    treatmentId,
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
                treatmentDescription,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {start_treatment(context, treatmentId, videosList);},
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

  start_treatment(BuildContext context, String treatmentId,
      List<ExerciseVideo> videosList1) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return TreatmentView(
            videosList: videosList1,
          );
        },
      ),
    );
  }
}
