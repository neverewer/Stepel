import 'package:flutter/material.dart';

class StatisticBox extends StatelessWidget {
  const StatisticBox(
      {super.key, required this.value, required this.label, this.valueColor, this.valueFontSize, this.labelFontSize});
  final String value;
  final String label;
  final Color? valueColor;
  final double? valueFontSize;
  final double? labelFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: valueFontSize ?? 19, color: valueColor ?? Colors.blue, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              label,
              style: TextStyle(fontSize: labelFontSize ?? 14, fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}
