import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepel/services/local_storage_service.dart';

import '../db/database.dart';
import '../models/fit_data.dart';

class PedometrService {
  static PedometrService? instance;

  PedometrService._();

  static PedometrService getInstance() {
    instance ??= PedometrService._();
    return instance!;
  }

  static FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
  static AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'channelId', 'channelName',
      priority: Priority.high,
      importance: Importance.max,
      icon: 'flutter_logo',
      largeIcon: null,
      channelShowBadge: true);
  static DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestCriticalPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) {},
  );
  static AndroidInitializationSettings androidInitSettings = const AndroidInitializationSettings('flutter_logo');
  static InitializationSettings initSettings = InitializationSettings(android: androidInitSettings, iOS: iosSettings);
  static NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  static String currentDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
  static DateTime currentDate = DateTime.parse(currentDateString);
  static int dayCardioPointsTarget = 40;
  static int preStepCount = 0;
  static int stepTarget = 8000;
  static final AppDb _db = AppDb();
  // static final FitData _fitData = FitData();

  // static Stream<FitData> get fitDataStream =>
  //     Pedometer.stepCountStream.asBroadcastStream().map((event) => _fitData..updateSteps(event.steps - preStepCount));

  static Future<void> initServiceInBackground() async {
    if (await checkPermissions() == false) {
      return;
    }
    await getPreviousSteps();
    await getStepDate();
    configureBackgroundService();
  }

  static void configureBackgroundService() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      return;
    }
    await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          autoStartOnBoot: true,
        ),
        iosConfiguration: IosConfiguration());
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    await getPreviousSteps();
    await getStepDate();
    //getAllSteps();
    Pedometer.stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  // static void getSteps() async {
  //   var a = await db.getStepsByDate(currentDate);
  //   print(a.steps);
  // }

  static void getAllSteps() async {
    var b = await _db.getAllSteps();
    for (int i = 0; i < b.length; i++) {
      print(b[i]);
    }
  }

  static void deleteAllSteps() {
    _db.deleteAllData();
  }

  static Future<bool> checkPermissions() async {
    return await Permission.activityRecognition.request().isGranted &&
        await Permission.notification.request().isGranted;
  }

  static void initNotifications() {
    notificationPlugin.initialize(initSettings, onDidReceiveBackgroundNotificationResponse: (_) {});
  }

  // static FitData getFitData() => _fitData;

  static Future<void> getPreviousSteps() async {
    var preSteps = await LocalStorageService.instance.getCurrentSteps();
    if (preSteps == null) {
      return;
    }
    preStepCount = preSteps;
  }

  static Future<void> getStepDate() async {
    var date = await LocalStorageService.instance.getStepDate();
    date != null
        ? currentDate = DateTime.parse(date)
        : LocalStorageService.instance.setStepDate(currentDate.toIso8601String());
  }

  static void setPreviousSteps(StepCount event) async {
    if (preStepCount != 0) {
      return;
    }
    preStepCount = event.steps;
    LocalStorageService.instance.setCurrentSteps(preStepCount);
  }

  static void updatePreviousSteps(int preSteps) async {
    LocalStorageService.instance.setCurrentSteps(preSteps);
    preStepCount = preSteps;
  }

  static void updateStepDate() async {
    currentDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    LocalStorageService.instance.setStepDate(currentDate.toIso8601String());
  }

  static void updateFitData(StepCount event) async =>
      await _db.createOrUpdateSteps(Step(date: currentDate, steps: event.steps - preStepCount));

  static void onStepCount(StepCount event) {
    setPreviousSteps(event);
    if (event.timeStamp.day == currentDate.day) {
      updateFitData(event);
    } else {
      updateStepDate();
      updatePreviousSteps(event.steps);
    }
    // showFitNotification();
  }

  static void onStepCountError(error) {}

  // static void showFitNotification() {
  //   notificationPlugin.show(
  //       0,
  //       'Statistic',
  //       'steps: $stepCount, calories: ${calories.toInt()}, distance: ${distance.toStringAsFixed(1)} km,  cardio: $cardioPoints',
  //       notificationDetails);
  // }
}
