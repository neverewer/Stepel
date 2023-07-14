import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WeeklyBarChart extends StatefulWidget {
  const WeeklyBarChart({super.key, required this.data, required this.barColor});
  final List<double> data;
  final Color barColor;

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  double maxValue = 0;
  @override
  void initState() {
    maxValue = widget.data.reduce(max);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
        maxY: maxValue,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles)),
        ),
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 20,
              tooltipBorder: const BorderSide(width: 0.01, color: Colors.grey),
            )),
        barGroups: widget.data
            .asMap()
            .entries
            .map((entry) => BarChartGroupData(x: entry.key.toInt(), barRods: [
                  BarChartRodData(
                    toY: entry.value,
                    color: widget.barColor,
                    width: 14,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                  )
                ]))
            .toList()));
  }
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'П';
      break;
    case 1:
      text = 'В';
      break;
    case 2:
      text = 'С';
      break;
    case 3:
      text = 'Ч';
      break;
    case 4:
      text = 'П';
      break;
    case 5:
      text = 'С';
      break;
    case 6:
      text = 'В';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: style),
  );
}
