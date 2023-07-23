import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String icon = 'flutter_logo';
  static FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
  static AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
    'steps',
    'stepsCount',
    priority: Priority.max,
    importance: Importance.none,
    icon: icon,
    largeIcon: null,
    channelShowBadge: false,
    ongoing: true,
    playSound: false,
    autoCancel: false,
  );
  static DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestCriticalPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) {},
  );
  static AndroidInitializationSettings androidInitSettings = const AndroidInitializationSettings(icon);
  static InitializationSettings initSettings = InitializationSettings(android: androidInitSettings, iOS: iosSettings);
  static NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  static Future<void> init() async {
    await notificationPlugin.initialize(initSettings, onDidReceiveBackgroundNotificationResponse: (responce) {});
  }

  static void showFitNotification(int steps) =>
      notificationPlugin.show(0, 'Statistic', 'steps: $steps', notificationDetails);
}
