import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardioLabel extends StatelessWidget {
  const CardioLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/heart.svg',
            width: 14, height: 14, colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn)),
        const SizedBox(width: 5),
        const Text(
          'Кардио-баллы',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
