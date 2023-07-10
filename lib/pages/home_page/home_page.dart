import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stepel/widgets/bar_chart.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 30, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBar(),
          SizedBox(
            height: 25,
          ),
          Chart(),
          SizedBox(
            height: 20,
          ),
          ChartBottomLabel(),
          SizedBox(
            height: 30,
          ),
          StatisticLine(),
          SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ТЕНДЕНЦИИ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              )),
          SizedBox(
            height: 15,
          ),
          TrendsBox(),
        ],
      ),
    ));
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info_outline,
              size: 24,
            )),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.green,
        )
      ],
    );
  }
}

class ChartBottomLabel extends StatelessWidget {
  const ChartBottomLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [CardioLabel(), SizedBox(width: 10), StepsLabel()],
    );
  }
}

class StatisticLine extends StatelessWidget {
  const StatisticLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatisticBox(
          value: 370.toString(),
          label: 'Cal',
        ),
        StatisticBox(
          value: 1.8.toString(),
          label: 'km',
        ),
        StatisticBox(
          value: 17.toString(),
          label: 'Move min',
        ),
      ],
    );
  }
}

class StatisticBox extends StatelessWidget {
  const StatisticBox({super.key, required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 19, color: Colors.blue, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      SleekCircularSlider(
        appearance: CircularSliderAppearance(
            size: 180,
            startAngle: 270,
            angleRange: 360,
            customWidths: CustomSliderWidths(
              progressBarWidth: 10,
              trackWidth: 10,
            ),
            customColors: CustomSliderColors(
                trackColor: const Color.fromARGB(255, 2, 173, 102).withOpacity(0.2),
                progressBarColor: const Color.fromARGB(255, 2, 173, 102),
                shadowMaxOpacity: 0,
                dotColor: Colors.transparent),
            infoProperties: InfoProperties(
              modifier: (value) {
                return value.toStringAsFixed(0);
              },
            )),
        min: 0,
        max: 8000,
        initialValue: 1280,
        innerWidget: (value) {
          return const SizedBox();
        },
      ),
      SleekCircularSlider(
          appearance: CircularSliderAppearance(
              size: 140,
              startAngle: 270,
              angleRange: 360,
              customWidths: CustomSliderWidths(
                progressBarWidth: 10,
                trackWidth: 10,
              ),
              customColors: CustomSliderColors(
                  trackColor: Colors.blue.withOpacity(0.2),
                  progressBarColor: Colors.blue,
                  shadowMaxOpacity: 0,
                  dotColor: Colors.transparent),
              infoProperties: InfoProperties(
                modifier: (value) {
                  return value.toStringAsFixed(0);
                },
              )),
          min: 0,
          max: 150,
          initialValue: 17)
    ]);
  }
}

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

class TrendsBox extends StatelessWidget {
  const TrendsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 160,
        child: DecoratedBox(
          decoration:
              const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 0.1,
            )
          ]),
          child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Баллы кардиотренировок',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'За последние 7 дней',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                      )
                    ],
                  ),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatisticBox(value: 0.toString(), label: 'Сегодня'),
                      const SizedBox(
                          height: 80,
                          width: 220,
                          child: WeeklyBarChart(data: [10, 0, 25, 30, 40, 0, 0], barColor: Colors.blue)),
                    ],
                  ))
                ],
              )),
        ));
  }
}
