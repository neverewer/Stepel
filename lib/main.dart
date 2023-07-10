import 'package:flutter/material.dart';
import 'package:stepel/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp.router(debugShowCheckedModeBanner: false, routerConfig: appRouter.config());
  }
}
