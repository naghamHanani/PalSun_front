import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_back/data/health_details.dart';
import 'package:test_back/util/responsive.dart';
import'../widgets/custom_card_widget.dart';

class ActivityDetailsCard extends StatefulWidget {
  const ActivityDetailsCard({super.key});

  @override
  State<ActivityDetailsCard> createState() => _ActivityDetailsCardState();
}

class _ActivityDetailsCardState extends State<ActivityDetailsCard> {

    late StreamSubscription<double> _pvGenerationSubscription;
  double _pvGeneration = 0; // Local variable to hold the pvGenerationValue

    @override
  void initState() {
    super.initState();

  
    // Listen for changes in pvGenerationValue
    _pvGenerationSubscription = HealthDetails().pvGenerationStream.listen((newPvGeneration) {
       print("Received new pvGeneration: $newPvGeneration");
       setState(() {
      _pvGeneration = newPvGeneration;
    });
  },
  onError: (error) {
    print("Stream error: $error");
    });
  }

  @override
  void dispose() {
    // Don't forget to cancel the subscription when the widget is disposed
    _pvGenerationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthDetails = HealthDetails();


    return GridView.builder(
      itemCount: healthDetails.healthData.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
        crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) => CustomCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Icon(
              healthDetails.healthData[index].icon,
              size: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                 index == 1 // Assuming index 1 is the "Today's total Pv Generation"
                      ? _pvGeneration.toStringAsFixed(2) // Use the updated value
                      : healthDetails.healthData[index].value,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              healthDetails.healthData[index].title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
