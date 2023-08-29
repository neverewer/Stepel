import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stepel/app/app.dart';
import 'package:stepel/router/router.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    await initializeDateFormatting('ru', null);
    var appRouter = AppRouter();
    await appRouter.init();
    runApp(App(appRouter: appRouter));
  }, (error, stackTrace) {
    log('app:', error: error, stackTrace: stackTrace);
  });
}
