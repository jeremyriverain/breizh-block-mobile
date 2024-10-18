import 'package:breizh_blok_mobile/components/bb_bar_chart.dart';
import 'package:breizh_blok_mobile/components/stats_session_best_perf_chart.dart';
import 'package:flutter/material.dart';

class StatsView extends StatelessWidget {
  const StatsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistiques',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              BbBarChart(
                title: 'Répartition des blocs réalisés',
                data: {'6a': 4, '6a+': 2, '6b': 1},
              ),
              SizedBox(
                height: 50,
              ),
              StatsSessionBestPerfChart(),
            ],
          ),
        ),
      ),
    );
  }
}
