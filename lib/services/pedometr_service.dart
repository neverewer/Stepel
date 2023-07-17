import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepel/services/local_storage_service.dart';

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

  static DateTime stepDate = DateTime.now();
  static int stepCount = 0;
  static double distance = 0.0;
  static double calories = 0.0;
  static int cardioPoints = 0;
  static int dayCardioPointsTarget = 40;
  int walkingTimeInSeconds = 0;
  static int preStepCount = 0;
  static int stepTarget = 8000;

  static Stream<List<Object>> get fitDataStream => Pedometer.stepCountStream.asBroadcastStream().map((event) {
        var steps = event.steps - preStepCount;
        var calories = steps * 0.04;
        var distance = steps * 0.0007;
        var cardioPoints = (steps * 0.005).toInt();
        return [steps, calories, distance, cardioPoints];
      });

  static Future<void> initServiceInBackground() async {
    if (await checkPermissions()) {
      await getPreviousSteps();
      await getStepDate();
      configureBackgroundService();
    }
  }

  static void configureBackgroundService() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning() == false) {
      await service.configure(
          androidConfiguration: AndroidConfiguration(
            onStart: onStart,
            autoStart: true,
            isForegroundMode: true,
            autoStartOnBoot: true,
          ),
          iosConfiguration: IosConfiguration());
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    Pedometer.stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  static Future<bool> checkPermissions() async {
    return await Permission.activityRecognition.request().isGranted &&
        await Permission.notification.request().isGranted;
  }

  //Future<void> initServiceInForegraund() async {}

  static void initNotifications() {
    notificationPlugin.initialize(initSettings, onDidReceiveBackgroundNotificationResponse: (_) {});
  }

  static Future<void> getPreviousSteps() async {
    var preSteps = (await LocalStorageService.instance.getCurrentSteps());
    if (preSteps != null) {
      preStepCount = preSteps;
    }
  }

  static Future<void> getStepDate() async {
    var date = await LocalStorageService.instance.getStepDate();
    date != null
        ? stepDate = DateTime.parse(date)
        : LocalStorageService.instance.setStepDate(stepDate.toIso8601String());
  }

  static void setPreviousSteps(StepCount event) {
    if (preStepCount == 0) {
      preStepCount = event.steps;
      LocalStorageService.instance.setCurrentSteps(preStepCount);
    }
  }

  static void updatePreviousSteps(int preSteps) {
    LocalStorageService.instance.setCurrentSteps(preSteps);
  }

  static void updateStepDate() {
    stepDate = DateTime.now();
    LocalStorageService.instance.setStepDate(stepDate.toIso8601String());
  }

  static void resetFitData() {
    stepCount = 0;
    calories = 0;
    distance = 0;
    cardioPoints = 0;
  }

  static void updateFitData(StepCount event) {
    stepCount = event.steps - preStepCount;
    calories = stepCount * 0.04;
    distance = stepCount * 0.0007;
    cardioPoints = (stepCount * 0.005).toInt();
  }

  static void onStepCount(StepCount event) {
    setPreviousSteps(event);
    if (event.timeStamp.day == stepDate.day) {
      updateFitData(event);
    } else {
      updateStepDate();
      updatePreviousSteps(event.steps);
      resetFitData();
    }
    showFitNotification();
  }

  static void onStepCountError(error) {}

  static void showFitNotification() {
    notificationPlugin.show(
        0,
        'Statistic',
        'steps: $stepCount, calories: ${calories.toInt()}, distance: ${distance.toStringAsFixed(1)} km,  cardio: $cardioPoints',
        notificationDetails);
  }
}


      // notificationPlugin
      //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      //     ?.requestPermission();
      // DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      //   requestCriticalPermission: true,
      //   onDidReceiveLocalNotification: (id, title, body, payload) {},
      // );
      // AndroidInitializationSettings androidInitSettings = const AndroidInitializationSettings('flutter_logo');
      // InitializationSettings initSettings = InitializationSettings(android: androidInitSettings, iOS: iosSettings);
      // notificationPlugin.initialize(initSettings,
      //     onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) {});
      // NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      // notificationPlugin.show(0, 'event', step.steps.toString(), notificationDetails);
      