import 'package:flutter/material.dart';
import 'package:test_back/data/bar_graph_data.dart';
import 'package:test_back/util/responsive.dart';
import 'package:test_back/widgets/bar_chart_sample.dart';
import 'package:test_back/widgets/custom_card_widget.dart';

class BarGraphCard extends StatelessWidget {
  const BarGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    final barGraphData = BarGraphData();

    return GridView.builder(
      itemCount: barGraphData.data.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2: 3,
        crossAxisSpacing: Responsive.isMobile(context) ? 10 : 15,
        mainAxisSpacing: 12.0,
        childAspectRatio: 5 / 4,
      ),
      itemBuilder: (context, index) {
        return CustomCard(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  barGraphData.data[index].label,
                  style: TextStyle(
                  color: Colors.white,
                 fontWeight: FontWeight.w500,
                fontSize: 14,
                  )
                ),
              ),
              const SizedBox(height: 10),
              
              SizedBox(
               height: Responsive.isMobile(context)? 120 :150, 
                child: BarChartSample1(touchedBarColor : barGraphData.data[index].color)
              ),
              
            ],
          ),
        );
      },
    );
  }

}