import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stepel/blocks/home_page/home_page_cubit.dart';
import 'package:stepel/blocks/home_page/home_page_state.dart';
import 'package:stepel/pages/info_page/info_page.dart';
import 'package:stepel/widgets/bar_chart.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => HomePageCubit(),
        child: BlocBuilder<HomePageCubit, HomePageState>(builder: (context, state) {
          switch (state.runtimeType) {
            case InitialHomePageState:
              return const LoadingForm();
            case LoadedHomePageState:
              return HomePageForm(state: state as LoadedHomePageState);
            default:
              return const SizedBox();
          }
        }));
  }
}

class LoadingForm extends StatelessWidget {
  const LoadingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.blue,
      )),
    );
  }
}

class HomePageForm extends StatelessWidget {
  const HomePageForm({super.key, required this.state});
  final LoadedHomePageState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
            child: HomePageScrollView(child: HomePageFormBody(state: state))));
  }
}

class HomePageScrollView extends StatelessWidget {
  const HomePageScrollView({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}

class HomePageFormBody extends StatelessWidget {
  const HomePageFormBody({super.key, required this.state});
  final LoadedHomePageState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppBar(),
        const SizedBox(
          height: 30,
        ),
        Chart(
          steps: state.steps!,
          cardioPoints: state.cardioPoints!,
          stepsTarget: state.stepsTarget!,
          cardiPointsTarget: state.dayCardioPointsTarget!,
        ),
        const SizedBox(
          height: 20,
        ),
        const ChartBottomLabel(),
        const SizedBox(
          height: 30,
        ),
        StatisticLine(calories: state.calories!, distance: state.distance!, moveTimeInMinutes: 10),
        const SizedBox(
          height: 20,
        ),
        const CategoryLabel(text: 'ТЕНДЕНЦИИ'),
        const SizedBox(
          height: 5,
        ),
        TrendsBox(
          topLabel: 'Баллы кардиотренировок',
          value: state.cardioPoints!,
        ),
        TrendsBox(
          topLabel: 'Шаги',
          value: state.steps!,
          color: const Color.fromARGB(255, 2, 173, 102),
        ),
        TrendsBox(
          topLabel: 'Расход энергии',
          value: state.calories!,
          color: Colors.deepPurpleAccent,
        ),
        const SizedBox(
          height: 20,
        ),
        const CategoryLabel(text: 'РЕКОМЕНДАЦИИ'),
        const RecomendationBox(
            topLabel: 'Рекомендуемая \nпродолжительность сна',
            description: 'Узнайте, какие факторы влияют на сон и сколько нужно спать именно вам, чтобы высыпаться')
      ],
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    showInfoDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(filter: ImageFilter.dilate(), child: const InfoPage());
          });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              showInfoDialog();
            },
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
  const StatisticLine({super.key, required this.calories, required this.distance, required this.moveTimeInMinutes});
  final int calories;
  final double distance;
  final int moveTimeInMinutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatisticBox(
          value: calories.toString(),
          label: 'Cal',
        ),
        StatisticBox(
          value: distance.toStringAsFixed(1),
          label: 'km',
        ),
        StatisticBox(
          value: moveTimeInMinutes.toString(),
          label: 'Move min',
        ),
      ],
    );
  }
}

class StatisticBox extends StatelessWidget {
  const StatisticBox({super.key, required this.value, required this.label, this.valueColor});
  final String value;
  final String label;
  final Color? valueColor;

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
              style: TextStyle(fontSize: 19, color: valueColor ?? Colors.blue, fontWeight: FontWeight.w700),
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
  const Chart(
      {super.key,
      required this.steps,
      required this.cardioPoints,
      required this.stepsTarget,
      required this.cardiPointsTarget});
  final int steps;
  final int cardioPoints;
  final int cardiPointsTarget;
  final int stepsTarget;

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
                dotColor: Colors.transparent)),
        min: 0,
        max: stepsTarget.toDouble(),
        initialValue: steps > stepsTarget ? stepsTarget.toDouble() : steps.toDouble(),
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
                dotColor: Colors.transparent)),
        min: 0,
        max: cardiPointsTarget.toDouble(),
        initialValue: cardioPoints > cardiPointsTarget ? cardiPointsTarget.toDouble() : cardioPoints.toDouble(),
        innerWidget: (value) {
          return const SizedBox();
        },
      ),
      Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(steps.toString(),
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 2, 173, 102))),
          Text(cardioPoints.toString(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.blue))
        ],
      ))
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
  const TrendsBox({super.key, required this.topLabel, required this.value, this.color});
  final String topLabel;
  final int value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
        child: SizedBox(
            width: double.infinity,
            height: 130,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            topLabel,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'За последние 7 дней',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                          )
                        ],
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatisticBox(
                            value: value.toString(),
                            label: 'Сегодня',
                            valueColor: color,
                          ),
                          SizedBox(
                              height: double.infinity,
                              width: 220,
                              child: WeeklyBarChart(
                                  data: const [10, 5, 25, 30, 40, 20, 24], barColor: color ?? Colors.blue)),
                        ],
                      ))
                    ],
                  )),
            )));
  }
}

class RecomendationBox extends StatelessWidget {
  const RecomendationBox({super.key, required this.topLabel, required this.description});
  final String topLabel;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
        child: SizedBox(
          width: double.infinity,
          height: 130,
          child: DecoratedBox(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 0.1,
                    )
                  ]),
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        topLabel,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                              flex: 3,
                              child: Text(
                                description,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: SvgPicture.asset(
                                'assets/icons/sleep-30.svg',
                                width: 60,
                                height: 60,
                              ))
                        ],
                      )),
                    ],
                  ))),
        ));
  }
}

class CategoryLabel extends StatelessWidget {
  const CategoryLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ));
  }
}
