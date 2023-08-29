import 'dart:math';

import 'package:stepel/imports.dart';

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

  var date = DateTime.now().subtract(Duration(days: 7 - (value.toInt() + 1)));
  var weekDay = date.weekday;

  String text;
  switch (weekDay) {
    case 1:
      text = 'П';
      break;
    case 2:
      text = 'В';
      break;
    case 3:
      text = 'С';
      break;
    case 4:
      text = 'Ч';
      break;
    case 5:
      text = 'П';
      break;
    case 6:
      text = 'С';
      break;
    case 7:
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
