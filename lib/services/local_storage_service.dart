import 'package:stepel/imports.dart';

class LocalStorageService with LocalStorageCache, LocalStorageApi {
  static final LocalStorageService _$instance = LocalStorageService._();
  static LocalStorageService get instance => _$instance;
  LocalStorageService._();
}

mixin LocalStorageCache {
  //init storage using Shared Preferences
  late final Future<SharedPreferences> _$db = SharedPreferences.getInstance();
}

mixin LocalStorageApi on LocalStorageCache {
  Future<void> setFirstAppRun(bool firstAppRun) => _$db.then((db) => db.setBool('FIRSTAPPRUN', firstAppRun));
  Future<bool?> getFirstAppRun() => _$db.then((db) => db.getBool('FIRSTAPPRUN'));
  Future<void> setCurrentSteps(int steps) => _$db.then((db) => db.setInt('CURRENTSTEPS', steps));
  Future<int?> getCurrentSteps() => _$db.then((db) => db.getInt('CURRENTSTEPS'));
  Future<void> setStepDate(String date) => _$db.then((db) => db.setString('STEPDATE', date));
  Future<String?> getStepDate() => _$db.then((db) => db.getString('STEPDATE'));
  Future<void> setPermissionsGranted(bool permissionsGranted) =>
      _$db.then((db) => db.setBool('PERMISSIONSGRANTED', permissionsGranted));
  Future<bool?> getPermissionsGranted() => _$db.then((db) => db.getBool('PERMISSIONSGRANTED'));
  Future<int?> getStepsTarget() => _$db.then((db) => db.getInt('STEPSTARGET'));
  Future<void> setStepTarget(int stepsTarget) => _$db.then((db) => db.setInt('STEPSTARGET', stepsTarget));
  Future<int?> getCardioPointsTarget() => _$db.then((db) => db.getInt('CARDIOPOINTSTARGET'));
  Future<void> setCardioPointsTartget(int cardioPointsTarget) =>
      _$db.then((db) => db.setInt('CARDIOPOINTSTARGET', cardioPointsTarget));
  Future<bool?> getSleepingModeActive() => _$db.then((db) => db.getBool('SLEEPINGMODEACTIVE'));
  Future<void> setSleepingModeActive(bool isActive) => _$db.then((db) => db.setBool('SLEEPINGMODEACTIVE', isActive));
  Future<int?> getWakeUpTimeHours() => _$db.then((db) => db.getInt('WAKEUPTIMEHOURS'));
  Future<void> setWakeUpTimeHours(int wakeUpTimeHours) =>
      _$db.then((db) => db.setInt('WAKEUPTIMEHOURS', wakeUpTimeHours));
  Future<int?> getWakeUpTimeMinutes() => _$db.then((db) => db.getInt('WAKEUPTIMEMINUTES'));
  Future<void> setWakeUpTimeMinutes(int wakeUpTimeMinutes) =>
      _$db.then((db) => db.setInt('WAKEUPTIMEMINUTES', wakeUpTimeMinutes));
  Future<int?> getTimeToSleepHours() => _$db.then((db) => db.getInt('TIMETOSLEEPHOURS'));
  Future<void> setTimeToSleepHours(int timeToSleepHours) =>
      _$db.then((db) => db.setInt('TIMETOSLEEPHOURS', timeToSleepHours));
  Future<int?> getTimeToSleepMinutes() => _$db.then((db) => db.getInt('TIMETOSLEEPMINUTES'));
  Future<void> setTimeToSleepMinutes(int timeToSleepMinutes) =>
      _$db.then((db) => db.setInt('TIMETOSLEEPMINUTES', timeToSleepMinutes));
}
