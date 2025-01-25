

import 'package:flutter/material.dart';
import 'package:test_back/data/consumption_data.dart';
import 'package:test_back/widgets/custom_card_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Scheduled extends StatelessWidget {
  const Scheduled({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ConsumptionData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "details",
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          SizedBox(
          height: 150,width:120,
          child: CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 13.0,
            animation: true,
            percent: 0.7,
            center: new Text(
               "70.0%",
                style:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
                  ),
            footer: Padding(
              padding: const EdgeInsets.only(top :10.0),
              child: new Text(
                   "Autarky Rate",
                     style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
                      ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.purple,
            ),
          ),

          SizedBox(width:20,),

          SizedBox(
          height: 150,width:120,
          
          child: CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 13.0,
            animation: true,
            percent: 0.7,
            center: new Text(
               "70.0%",
                style:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
                  ),
            footer: Padding(
              padding: const EdgeInsets.only(top :10.0),
              child: new Text(
                   "Self supply",
                     style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
                      ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color.fromARGB(255, 85, 73, 147),
            ),
          ),

          ],
        ),
       
        
        SizedBox(height: 20,),
         


        // for (var index = 0; index < data.scheduled.length; index++)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 5),
        //     child: CustomCard(
        //       color: Colors.black,
        //       child: Column(
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     data.scheduled[index].title,
        //                     style: const TextStyle(
        //                         fontSize: 12, fontWeight: FontWeight.w500),
        //                   ),
        //                   const SizedBox(height: 2),
        //                   Text(
        //                     data.scheduled[index].date,
        //                     style: const TextStyle(
        //                         fontSize: 12,
        //                         color: Colors.grey,
        //                         fontWeight: FontWeight.w500),
        //                   ),
        //                 ],
        //               ),
        //               const Icon(Icons.more),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}