import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocks/home_page/home_page_state.dart';
import 'package:stepel/services/pedometr_service.dart';

class HomePageCubit extends Cubit<HomePageState> {
  PedometrService pedometrService = PedometrService.getInstance();

  HomePageCubit() : super(InitialHomePageState()) {
    init();
  }

  late StreamSubscription dataStreamSubscription;

  void init() async {
    await pedometrService.init();
    dataStreamSubscription = pedometrService.dataStream.stream.listen((event) => emit(LoadedHomePageState(
        steps: event[0] as int, calories: (event[1] as double).toInt(), distance: event[2] as double)));
    emit(LoadedHomePageState(
        steps: pedometrService.stepCount,
        calories: pedometrService.calories.toInt(),
        distance: pedometrService.distance,
        stepsTarget: pedometrService.stepTarget));
  }
}
