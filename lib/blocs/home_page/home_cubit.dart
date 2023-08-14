import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/home_page/home_state.dart';
import 'package:stepel/models/profile_data_update_event.dart';
import 'package:stepel/repositories/fit_data_repository.dart';
import 'package:stepel/repositories/profile_data_repository.dart';

import '../../services/notification_service.dart';
import '../../services/pedometr_service/pedometr_service_background.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.fitDataRepo, required this.profileDataRepo}) : super(const HomeState.idle());

  final FitDataRepositoryImp fitDataRepo;
  final ProfileDataRepositoryImp profileDataRepo;

  late StreamSubscription _pedometrSubscription;
  late StreamSubscription _profileDataSubscription;

  void init() async {
    await initializeServices();
    getInitialData();
    initSubscriptions();
  }

  Future<void> initializeServices() async {
    await NotificationService.init();
    PedometrServiceBackground.init();
  }

  void initSubscriptions() {
    _pedometrSubscription = fitDataRepo.fitDataStream.listen((event) {
      emit((state as HomeState$Successful).copyWith(fitData: event));
    });

    _profileDataSubscription = profileDataRepo.profileDataUpdates.listen((event) {
      switch (event.updatedField) {
        case ProfileDataField.stepTarget:
          emit((state as HomeState$Successful).copyWith(stepTarget: event.value.toInt()));
          break;
        case ProfileDataField.cardioPointsTarget:
          emit((state as HomeState$Successful).copyWith(dayCardioPointsTarget: event.value.toInt()));
          break;
        case ProfileDataField.weigth:
          // Добавьте необходимые действия для обновления веса
          break;
        case ProfileDataField.heigth:
          // Добавьте необходимые действия для обновления роста
          break;
        default:
          break;
      }
    });
  }

  void getInitialData() async {
    try {
      emit(const HomeState.processing());

      var fitData = await fitDataRepo.getCurrentFitData();
      var cardioPointsTarget = await profileDataRepo.getCardioPointsTarget();
      var stepTarget = await profileDataRepo.getStepsTarget();
      var weeklyData = await fitDataRepo.getWeeklyData();

      emit(HomeState.successful(
        fitData: fitData,
        dayCardioPointsTarget: cardioPointsTarget,
        stepTarget: stepTarget,
        weeklyData: weeklyData,
      ));
    } catch (e) {
      emit(const HomeState.error());
    }
  }

  void disposeSubscriptions() {
    _pedometrSubscription.cancel();
    _profileDataSubscription.cancel();
  }

  @override
  Future<void> close() {
    disposeSubscriptions();
    return super.close();
  }
}
