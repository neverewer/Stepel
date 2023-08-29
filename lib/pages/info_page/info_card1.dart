import 'package:stepel/imports.dart';

class InfoCard1 extends StatelessWidget {
  const InfoCard1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Отслеживайте свою нагрузку со Stepel',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 25,
        ),
        SvgPicture.asset(
          'assets/icons/heart.svg',
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Баллы кардиотренировок',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          'Чтобы заработать баллы, больше двигайтесь',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        const SizedBox(
          height: 25,
        ),
        SvgPicture.asset(
          'assets/icons/sprint.svg',
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(Color.fromARGB(255, 2, 173, 102), BlendMode.srcIn),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text('Шаги', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 3,
        ),
        Text(
          'Чтобы достичь цели, находитесь в движении',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        const SizedBox(
          height: 25,
        ),
        const Text('В приложении Stepel не только подсчитываются шаги, но и начисляются баллы кардиотренировок',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
