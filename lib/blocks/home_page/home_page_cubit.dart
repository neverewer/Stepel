import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocks/home_page/home_page_state.dart';
import 'package:stepel/services/pedometr_service.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(InitialHomePageState()) {
    init();
  }

  void init() {
    initPedometrSubscription();
    loadFitData();
  }

  void initPedometrSubscription() {
    PedometrService.fitDataStream.listen((event) => emit((state as LoadedHomePageState).copyWith(
        steps: event[0] as int,
        calories: (event[1] as double).toInt(),
        distance: event[2] as double,
        cardioPoints: event[3] as int)));
  }

  void loadFitData() {
    emit(LoadedHomePageState(
        steps: PedometrService.stepCount,
        calories: PedometrService.calories.toInt(),
        distance: PedometrService.distance,
        stepsTarget: PedometrService.stepTarget,
        cardioPoints: PedometrService.cardioPoints,
        dayCardioPointsTarget: PedometrService.dayCardioPointsTarget));
  }
}
