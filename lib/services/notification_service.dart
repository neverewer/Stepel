import 'package:stepel/imports.dart';
import 'package:timezone/timezone.dart' as tz;

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

  static AndroidNotificationDetails scheduleAndroidNotificationDetails = const AndroidNotificationDetails(
    'daily',
    'sleep mode',
    priority: Priority.max,
    importance: Importance.max,
    icon: _icon,
    largeIcon: null,
    channelShowBadge: true,
    playSound: true,
  );

  static NotificationDetails scheduleNotificationDetails =
      NotificationDetails(android: scheduleAndroidNotificationDetails);

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

  static void showOrUpdateFitNotification(int steps, int stepCount) {
    var stepsString = formatSteps(steps);
    notificationPlugin.show(
        0, 'Вы сделали $stepsString', 'Ваша цель на сегодня составляет $stepCount шагов', notificationDetails);
  }

  static void activateWakeUpNotifications(TimeOfDay time) {
    notificationPlugin.cancel(1);
    notificationPlugin.zonedSchedule(
      1,
      'Пора просыпаться',
      '',
      getScheduleDate(time),
      scheduleNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void activateTimeToSleepNotifications(TimeOfDay time) {
    notificationPlugin.cancel(2);
    notificationPlugin.zonedSchedule(
      2,
      'Пора ложиться спать',
      '',
      getScheduleDate(time),
      scheduleNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void deactivateSleepingModeNotifications() {
    notificationPlugin.cancel(1);
    notificationPlugin.cancel(2);
  }

  static tz.TZDateTime getScheduleDate(TimeOfDay time) {
    final DateTime now = DateTime.now();
    var scheduleDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduleDateTime, tz.local);

    return scheduledDate;
  }

  static String formatSteps(int steps) {
    if (steps == 1) {
      return '1 шаг';
    }

    String suffix;
    if (steps % 10 == 1 && steps % 100 != 11) {
      suffix = 'шаг';
    } else if (steps % 10 >= 2 && steps % 10 <= 4 && (steps % 100 < 10 || steps % 100 >= 20)) {
      suffix = 'шага';
    } else {
      suffix = 'шагов';
    }

    return '$steps $suffix';
  }
}
