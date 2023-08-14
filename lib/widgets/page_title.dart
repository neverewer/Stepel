import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.title, this.titleFontSize});
  final String title;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: titleFontSize ?? 18),
    );
  }
}
