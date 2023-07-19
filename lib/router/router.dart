import 'package:auto_route/auto_route.dart';
import 'package:stepel/router/router.gr.dart';
import 'package:stepel/services/local_storage_service.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  bool? firstAppRun;

  Future init() async {
    firstAppRun = await LocalStorageService.instance.getFirstAppRun();
    firstAppRun ??= true;
  }

  @override
  List<AutoRoute> get routes => firstAppRun!
      ? [
          AutoRoute(page: WelcomeRoute.page, path: '/'),
          AutoRoute(page: HomeRoute.page, path: '/home'),
        ]
      : [
          AutoRoute(page: HomeRoute.page, path: '/'),
        ];
}
