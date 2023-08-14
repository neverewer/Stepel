import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/journal_page/journal_cubit.dart';
import 'package:stepel/blocs/journal_page/journal_state.dart';
import 'package:stepel/widgets/loading_form.dart';

import '../../models/fit_data.dart';
import '../../widgets/cardio_label.dart';
import '../../widgets/circle_double_chart.dart';
import '../../widgets/page_title.dart';
import '../../widgets/statistic_box.dart';
import '../../widgets/steps_label.dart';

class JournalForm extends StatelessWidget {
  const JournalForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCubit, JournalState>(
        builder: ((context, state) => state.map(
            idle: (_) => const LoadingForm(),
            processing: (_) => const LoadingForm(),
            successful: (state) {
              if (state.hasData) {
                return DataWidget(data: state.data!);
              } else {
                return const SizedBox();
              }
            },
            error: (_) => const SizedBox())));
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget({super.key, required this.data});
  final List<FitData> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              actions: [AppBarActions()],
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 16, bottom: 15),
                  expandedTitleScale: 2,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [PageTitle(title: 'Журнал')],
                  )),
              expandedHeight: 120,
              pinned: true,
            )
          ],
          body: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: ((context, index) => ListItem(
                    date: data[index].dateToString(),
                    steps: data[index].steps,
                    cardioPoints: data[index].cardioPoints,
                    calories: data[index].calories.toInt(),
                    distance: data[index].moveDistance,
                    moveMin: data[index].moveMinutes,
                  ))),
        ));
  }
}

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () => context.read<JournalCubit>().init(),
                icon: const Icon(
                  Icons.autorenew_rounded,
                  size: 24,
                  color: Colors.black,
                )),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
            )
          ],
        ));
  }
}

class ListItem extends StatelessWidget {
  const ListItem(
      {super.key,
      required this.date,
      required this.steps,
      required this.cardioPoints,
      required this.calories,
      required this.distance,
      required this.moveMin});
  final String date;
  final int steps;
  final int cardioPoints;
  final int calories;
  final double distance;
  final int moveMin;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Text(date.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16))),
          const SizedBox(height: 10),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1.5,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatisticBox(
                        value: calories.toString(),
                        label: 'cal',
                        valueFontSize: 22,
                        labelFontSize: 16,
                      ),
                      const SizedBox(height: 15),
                      StatisticBox(
                        value: distance.toStringAsFixed(1),
                        label: 'km',
                        valueFontSize: 22,
                        labelFontSize: 16,
                      ),
                      const SizedBox(height: 15),
                      StatisticBox(
                        value: moveMin.toString(),
                        label: 'move min',
                        valueFontSize: 22,
                        labelFontSize: 16,
                      ),
                    ],
                  )),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleDoubleChart(
                        steps: steps,
                        cardioPoints: cardioPoints,
                        stepsTarget: 8000,
                        cardiPointsTarget: 40,
                        showLabel: true,
                        animationEnabled: false,
                        width: 6,
                        size: 110,
                        smallSize: 80,
                        stepsLabelFontSize: 22,
                        cardioLabelFontSize: 18,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StepsLabel(),
                          CardioLabel(),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ]));
  }
}
