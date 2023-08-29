import 'package:stepel/imports.dart';

class StepsLabel extends StatelessWidget {
  const StepsLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/sprint.svg',
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(Color.fromARGB(255, 2, 173, 102), BlendMode.srcIn)),
        const SizedBox(width: 5),
        const Text(
          'Шаги',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
