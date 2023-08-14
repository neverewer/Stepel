import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/profile_page/profile_state.dart';
import 'package:stepel/services/notification_service.dart';

import '../../repositories/profile_data_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileDataRepo}) : super(const ProfileState.idle());

  final ProfileDataRepositoryImp profileDataRepo;

  Future<void> init() async {
    emit(const ProfileState.processing());
    var stepsTarget = await profileDataRepo.getStepsTarget();
    var cardioPointsTarget = await profileDataRepo.getCardioPointsTarget();
    var isSleepingModeActive = await profileDataRepo.getSleepingModeIsActive();
    var wakeUpTime = await profileDataRepo.getWakeUpTime();
    var timeToSleep = await profileDataRepo.getTimeToSleep();
    emit(ProfileState.successful(
      stepsTarget: stepsTarget,
      cardioPointsTarget: cardioPointsTarget,
      isSleepingModeActive: isSleepingModeActive,
      wakeUpTime: wakeUpTime,
      timeToSleep: timeToSleep,
    ));
  }

  void setStepsTarget(int stepsTarget) {
    profileDataRepo.setStepsTarget(stepsTarget);
    emit((state as ProfileState$Successful).copyWith(stepsTarget: stepsTarget));
  }

  void setCardioPointsTarget(int cardioPointsTarget) {
    profileDataRepo.setCardioPointsTarget(cardioPointsTarget);
    emit((state as ProfileState$Successful).copyWith(cardioPointsTarget: cardioPointsTarget));
  }

  void activeDailySleepingModeNotifications(bool isActivate) {
    isActivate
        ? {
            NotificationService.activateWakeUpNotifications((state as ProfileState$Successful).wakeUpTime),
            NotificationService.activateTimeToSleepNotifications((state as ProfileState$Successful).timeToSleep),
          }
        : NotificationService.deactivateSleepingModeNotifications();
    profileDataRepo.setSleepingModeIsActive(isActivate);
    emit((state as ProfileState$Successful).copyWith(isSleepingModeActive: isActivate));
  }

  void setWakeUpTime(TimeOfDay wakeUpTime) {
    profileDataRepo.setWakeUpTime(wakeUpTime);
    NotificationService.activateWakeUpNotifications(wakeUpTime);
    emit((state as ProfileState$Successful).copyWith(wakeUpTime: wakeUpTime));
  }

  void setTimeToSleep(TimeOfDay timeToSleep) {
    profileDataRepo.setTimeToSleep(timeToSleep);
    NotificationService.activateTimeToSleepNotifications(timeToSleep);
    emit((state as ProfileState$Successful).copyWith(timeToSleep: timeToSleep));
  }
}
