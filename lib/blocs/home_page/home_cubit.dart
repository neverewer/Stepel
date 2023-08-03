import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/home_page/home_state.dart';
import 'package:stepel/repositories/fit_data_repository.dart';

import '../../services/notification_service.dart';
import '../../services/pedometr_service/pedometr_service_background.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.fitDataRepo}) : super(const HomeState.idle());

  final FitDataRepositoryImp fitDataRepo;
  StreamSubscription? _streamSubscription;

  void init() async {
    await initializeServices();
    getInitialData();
    initPedometrSubscription();
  }

  Future<void> initializeServices() async {
    await NotificationService.init();
    PedometrServiceBackground.init();
  }

  void initPedometrSubscription() {
    _streamSubscription =
        fitDataRepo.fitDataStream.listen((event) => emit(((state as HomeState$Successful).copyWith(fitData: event))));
  }

  void getInitialData() async {
    emit(const HomeState.processing());
    var fitData = await fitDataRepo.getCurrentFitData();
    var cardioPointsTarget = fitDataRepo.getCardioPointsTarget();
    var stepTarget = fitDataRepo.getStepsTarget();
    var weeklyData = await fitDataRepo.getWeeklyData();
    emit(HomeState.successful(
        fitData: fitData, dayCardioPointsTarget: cardioPointsTarget, stepTarget: stepTarget, weeklyData: weeklyData));
  }

  @override
  Future<void> close() {
    _streamSubscription!.cancel();
    return super.close();
  }
}
