import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/home_page/home_state.dart';
import 'package:stepel/services/pedometr_service/pedometr_service_foreground.dart';

import '../../services/notification_service.dart';
import '../../services/pedometr_service/pedometr_service_background.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.idle());

  final PedometrServiceForeground pedometrService = PedometrServiceForeground();
  StreamSubscription? _streamSubscription;

  void init() async {
    await initializeServices();
    loadFitData();
    initPedometrSubscription();
  }

  Future<void> initializeServices() async {
    await NotificationService.init();
    PedometrServiceBackground.init();
    await PedometrServiceForeground().init();
  }

  void initPedometrSubscription() {
    _streamSubscription = pedometrService.fitDataStream
        .listen((event) => emit(((state as HomeState$Successful).copyWith(fitData: event))));
  }

  void loadFitData() async {
    emit(const HomeState.processing());
    var fitData = pedometrService.getFitData();
    var cardioPointsTarget = pedometrService.getCardioPointsTarget();
    var stepTarget = pedometrService.getStepsTarget();
    var weeklyData = await pedometrService.getWeeklyData();
    emit(HomeState.successful(
        fitData: fitData, dayCardioPointsTarget: cardioPointsTarget, stepTarget: stepTarget, weeklyData: weeklyData));
  }

  @override
  Future<void> close() {
    _streamSubscription!.cancel();
    return super.close();
  }
}
