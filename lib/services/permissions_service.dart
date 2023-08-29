import 'package:stepel/imports.dart';

class PermissionsService {
  static Future<bool> checkPermissions() async {
    return await Permission.activityRecognition.request().isGranted &&
        await Permission.notification.request().isGranted;
  }
}
