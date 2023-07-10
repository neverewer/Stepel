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
}
