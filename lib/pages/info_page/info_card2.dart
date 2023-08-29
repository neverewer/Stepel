import 'package:stepel/imports.dart';

class InfoCard2 extends StatelessWidget {
  const InfoCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Как зарабатывать баллы кардиотренировок',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        SvgPicture.asset(
          'assets/icons/heart.svg',
          width: 45,
          height: 45,
          colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        ),
        const Text(
          'Получайте баллы кардиотренировок за любую активность, например ходьбу или езду на велосипеде.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
