import 'package:breizh_blok_mobile/components/bb_bar_chart_title.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BoulderAreaDetailsPerformanceTabBarChart extends StatelessWidget {
  const BoulderAreaDetailsPerformanceTabBarChart({
    required this.data,
    this.title,
    super.key,
  });

  final Map<String, ({int part, int total})> data;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final values = data.values;
    final keys = data.keys;
    final max = values
        .reduce(
          (value, element) => value.total > element.total ? value : element,
        )
        .total;

    final title_ = title;
    return Column(
      children: [
        if (title_ != null) BbBarChartTitle(title: title_),
        AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData(keys.toList()),
              borderData: borderData,
              barGroups: barGroups(values.toList()),
              gridData: const FlGridData(
                show: false,
              ),
              alignment: BarChartAlignment.spaceAround,
              maxY: max > 10 ? max.toDouble() + 2 : max.toDouble() + 1,
            ),
          ),
        ),
      ],
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(),
            );
          },
        ),
      );

  FlTitlesData titlesData(List<String> titles) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 52,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );

            final key = titles[value.toInt()];
            final isComplete = data[key]?.part == data[key]?.total;

            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: isComplete
                  ? Column(
                      children: [
                        Text(key, style: style),
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 16,
                        ),
                      ],
                    )
                  : Text(key, style: style),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient _barsGradient({required bool isComplete}) {
    return LinearGradient(
      colors: [
        if (isComplete) Colors.amber else Colors.red,
        if (isComplete) Colors.green else Colors.amber,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  List<BarChartGroupData> barGroups(List<({int part, int total})> values) {
    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < values.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: 10,
              toY: values[i].part.toDouble(),
              gradient:
                  _barsGradient(isComplete: values[i].part == values[i].total),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: values[i].total.toDouble(),
                color: Colors.grey.shade200,
              ),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return barGroups;
  }
}
