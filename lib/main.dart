import 'package:flutter/material.dart';
import 'package:stepel/router/router.dart';
import 'package:stepel/services/pedometr_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appRouter = AppRouter();
  await appRouter.init();
  await PedometrService.getInstance().init();
  runApp(MainApp(
    appRouter: appRouter,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(debugShowCheckedModeBanner: false, routerConfig: appRouter.config());
  }
}
