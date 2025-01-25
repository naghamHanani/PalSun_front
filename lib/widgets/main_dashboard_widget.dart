import 'package:flutter/material.dart';
import 'package:test_back/util/responsive.dart';
import 'package:test_back/widgets/summary_widget.dart';
import 'header_widget.dart';
import 'activity_details_card.dart';
import 'line_chart_card.dart';
import 'bar_graph_widget.dart';

class MainDashboardWidget extends StatelessWidget {
  const MainDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 18),
            const HeaderWidget(),
            const SizedBox(height: 18),
            const ActivityDetailsCard(),
            const SizedBox(height: 18),
            const LineChartCard(),
            const SizedBox(height: 18),
            const BarGraphCard(),
            const SizedBox(height: 18),
            if (Responsive.isTablet(context)) const SummaryWidget(),
          ],
        ),
      ),
    );
  }
}
