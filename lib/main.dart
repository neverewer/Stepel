import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stepel/repositories/fit_data_repository.dart';
import 'package:stepel/repositories/profile_data_repository.dart';
import 'package:stepel/router/router.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    await initializeDateFormatting('ru', null);
    var appRouter = AppRouter();
    await appRouter.init();
    runApp(MainApp(appRouter: appRouter));
  }, (error, stackTrace) {
    log('app:', error: error, stackTrace: stackTrace);
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FitDataRepositoryImp()),
        RepositoryProvider(create: (_) => ProfileDataRepositoryImp())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
