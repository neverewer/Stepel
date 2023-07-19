import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stepel/router/router.dart';
import 'package:stepel/services/pedometr_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PedometrService.initServiceInBackground();
  var appRouter = AppRouter();
  await appRouter.init();
  runApp(MainApp(
    appRouter: appRouter,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return MaterialApp.router(debugShowCheckedModeBanner: false, routerConfig: appRouter.config());
  }
}
