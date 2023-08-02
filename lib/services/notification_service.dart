import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String _icon = 'flutter_logo';
  static FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
  static AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
    'steps',
    'stepsCount',
    priority: Priority.max,
    importance: Importance.max,
    icon: _icon,
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
  static AndroidInitializationSettings androidInitSettings = const AndroidInitializationSettings(_icon);
  static InitializationSettings initSettings = InitializationSettings(android: androidInitSettings, iOS: iosSettings);
  static NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  static Future<void> init() async {
    await notificationPlugin.initialize(initSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationRespone);
  }

  @pragma('vm:entry-point')
  static void onDidReceiveBackgroundNotificationRespone(NotificationResponse notificationResponse) {}

  static void showOrUpdateFitNotification(int steps) {
    try {
      notificationPlugin.show(
          0, 'Вы сделали $steps шагов', 'Ваша цель на сегодня составляет 8000 шагов', notificationDetails);
    } catch (e) {
      print(e);
    }
  }
}
