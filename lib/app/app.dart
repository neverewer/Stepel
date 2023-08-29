import 'package:stepel/imports.dart';

class App extends StatelessWidget {
  const App({super.key, required this.appRouter});

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
