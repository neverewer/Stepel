import 'dart:async';

import 'package:stepel/imports.dart';

abstract class ProfileDataRepository {
  Future<int> getStepsTarget();
  void setStepsTarget(int stepsTarget);
  Future<int> getCardioPointsTarget();
  void setCardioPointsTarget(int cardioPointsTarget);
  Future<bool> getSleepingModeIsActive();
  void setSleepingModeIsActive(bool isActive);
  Future<TimeOfDay> getTimeToSleep();
  Future<TimeOfDay> getWakeUpTime();
  void setWakeUpTime(TimeOfDay wakeUpTime);
  void setTimeToSleep(TimeOfDay timeToSleep);
}

class ProfileDataRepositoryImp extends ProfileDataRepository {
  final LocalStorageService _localStorageService = LocalStorageService.instance;

  final StreamController<ProfileDataUpdateEvent> _streamController = StreamController<ProfileDataUpdateEvent>();

  Stream<ProfileDataUpdateEvent> get profileDataUpdates => _streamController.stream;

  @override
  Future<int> getStepsTarget() async => await _localStorageService.getStepsTarget() ?? 8000;

  @override
  void setStepsTarget(int stepsTarget) async {
    await _localStorageService.setStepTarget(stepsTarget);
    _streamController.add(ProfileDataUpdateEvent(stepsTarget, ProfileDataField.stepTarget));
    FlutterBackgroundService().invoke("ChangeStepTarget", {'stepTarget': stepsTarget});
  }

  @override
  Future<int> getCardioPointsTarget() async => await _localStorageService.getCardioPointsTarget() ?? 40;

  @override
  void setCardioPointsTarget(int cardioPointsTarget) {
    _localStorageService.setCardioPointsTartget(cardioPointsTarget);
    _streamController.add(ProfileDataUpdateEvent(cardioPointsTarget, ProfileDataField.cardioPointsTarget));
  }

  @override
  Future<bool> getSleepingModeIsActive() async => await _localStorageService.getSleepingModeActive() ?? false;

  @override
  void setSleepingModeIsActive(bool isActive) {
    _localStorageService.setSleepingModeActive(isActive);
  }

  @override
  Future<TimeOfDay> getWakeUpTime() async {
    var wakeUpTimeHours = await _localStorageService.getWakeUpTimeHours() ?? 7;
    var wakeUpTimeMinutes = await _localStorageService.getWakeUpTimeMinutes() ?? 0;
    return TimeOfDay(hour: wakeUpTimeHours, minute: wakeUpTimeMinutes);
  }

  @override
  void setWakeUpTime(TimeOfDay wakeUpTime) {
    _localStorageService.setWakeUpTimeHours(wakeUpTime.hour);
    _localStorageService.setWakeUpTimeMinutes(wakeUpTime.minute);
  }

  @override
  Future<TimeOfDay> getTimeToSleep() async {
    var timeToSleepHours = await _localStorageService.getTimeToSleepHours() ?? 23;
    var timeToSleepMinutes = await _localStorageService.getTimeToSleepMinutes() ?? 0;
    return TimeOfDay(hour: timeToSleepHours, minute: timeToSleepMinutes);
  }

  @override
  void setTimeToSleep(TimeOfDay timeToSleep) {
    _localStorageService.setTimeToSleepHours(timeToSleep.hour);
    _localStorageService.setTimeToSleepMinutes(timeToSleep.minute);
  }
}
