import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stepel/widgets/loading_form.dart';

import '../../blocs/home_page/home_cubit.dart';
import '../../blocs/home_page/home_state.dart';
import '../../models/fit_data.dart';
import '../../widgets/bar_chart.dart';
import '../../widgets/cardio_label.dart';
import '../../widgets/circle_double_chart.dart';
import '../../widgets/statistic_box.dart';
import '../../widgets/steps_label.dart';
import '../info_page/info_page.dart';

class HomePageForm extends StatelessWidget {
  const HomePageForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => state.map(
            idle: (_) => const LoadingForm(),
            processing: (_) => const LoadingForm(),
            successful: (state) => DataWidget(
                  fitData: state.fitData,
                  stepTarget: state.stepTarget,
                  cardioPointsTarget: state.dayCardioPointsTarget,
                  weeklySteps: state.weeklyData['steps']!,
                  weeklyCardioPoints: state.weeklyData['cardioPoints']!,
                  weeklyCalories: state.weeklyData['calories']!,
                ),
            error: (_) => const SizedBox()));
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget(
      {super.key,
      required this.fitData,
      required this.stepTarget,
      required this.cardioPointsTarget,
      required this.weeklySteps,
      required this.weeklyCardioPoints,
      required this.weeklyCalories});
  final FitData fitData;
  final int stepTarget;
  final int cardioPointsTarget;
  final List<double> weeklySteps;
  final List<double> weeklyCardioPoints;
  final List<double> weeklyCalories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.only(top: 33, right: 16, left: 16),
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppBar(),
                    const SizedBox(
                      height: 30,
                    ),
                    CircleDoubleChart(
                      animationEnabled: true,
                      showLabel: true,
                      steps: fitData.steps,
                      cardioPoints: fitData.cardioPoints,
                      stepsTarget: stepTarget,
                      cardiPointsTarget: cardioPointsTarget,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ChartBottomLabel(),
                    const SizedBox(
                      height: 30,
                    ),
                    StatisticLine(
                        calories: fitData.calories.toInt(),
                        distance: fitData.moveDistance,
                        moveTimeInMinutes: fitData.moveMinutes),
                    const SizedBox(
                      height: 20,
                    ),
                    const CategoryLabel(text: 'ТЕНДЕНЦИИ'),
                    const SizedBox(
                      height: 5,
                    ),
                    TrendsBox(
                        topLabel: 'Баллы кардиотренировок', value: fitData.cardioPoints, data: weeklyCardioPoints),
                    TrendsBox(
                      topLabel: 'Шаги',
                      value: fitData.steps,
                      color: const Color.fromARGB(255, 2, 173, 102),
                      data: weeklySteps,
                    ),
                    TrendsBox(
                      topLabel: 'Расход энергии',
                      value: fitData.calories.toInt(),
                      color: Colors.deepPurpleAccent,
                      data: weeklyCalories,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CategoryLabel(text: 'РЕКОМЕНДАЦИИ'),
                    const RecomendationBox(
                        topLabel: 'Рекомендуемая \nпродолжительность сна',
                        description:
                            'Узнайте, какие факторы влияют на сон и сколько нужно спать именно вам, чтобы высыпаться')
                  ],
                ))));
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

class TrendsBox extends StatelessWidget {
  const TrendsBox({super.key, required this.topLabel, required this.value, this.color, required this.data});
  final String topLabel;
  final int value;
  final Color? color;
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 15, left: 2, right: 2),
        child: SizedBox(
            width: double.infinity,
            height: 130,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200, blurRadius: 0.2, spreadRadius: 1, blurStyle: BlurStyle.normal)
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
                              child: WeeklyBarChart(data: data, barColor: color ?? Colors.blue)),
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
        padding: const EdgeInsets.only(top: 15, left: 2, right: 2),
        child: SizedBox(
          width: double.infinity,
          height: 130,
          child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 2,
                      spreadRadius: 1,
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
