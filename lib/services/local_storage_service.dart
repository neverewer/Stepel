import 'package:shared_preferences/shared_preferences.dart';

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
}
