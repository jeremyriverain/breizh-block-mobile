import 'package:breizh_blok_mobile/components/boulder_area_details_performance_tab_bar_chart.dart';
import 'package:breizh_blok_mobile/components/boulder_area_details_performance_tab_progress_tracker.dart';
import 'package:breizh_blok_mobile/models/boulder_area.dart';
import 'package:flutter/material.dart';

class BoulderAreaDetailsPerformanceTab extends StatelessWidget {
  const BoulderAreaDetailsPerformanceTab({
    required this.boulderArea,
    super.key,
  });

  final BoulderArea boulderArea;

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Center(
          child: Column(
            children: [
              BoulderAreaDetailsPerformanceTabProgressTracker(
                completed: 18,
                total: 56,
                label: 'blocs réalisés',
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: BoulderAreaDetailsPerformanceTabBarChart(
                  title: 'Répartition des blocs réalisés',
                  data: {
                    '5c': (part: 5, total: 5),
                    '6a': (part: 1, total: 5),
                    '6a+': (part: 2, total: 10),
                    '6b': (part: 0, total: 8),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
