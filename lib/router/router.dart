import 'package:auto_route/auto_route.dart';
import 'package:stepel/router/router.gr.dart';
import 'package:stepel/services/local_storage_service.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  late final bool _firstAppRun;
  late final bool _permissionsGranted;

  Future<void> init() async {
    _firstAppRun = await LocalStorageService.instance.getFirstAppRun() ?? true;
    _permissionsGranted = await LocalStorageService.instance.getPermissionsGranted() ?? false;
  }

  @override
  List<AutoRoute> get routes {
    if (_firstAppRun && !_permissionsGranted) {
      return [
        AutoRoute(page: WelcomeRoute.page, path: '/'),
        AutoRoute(page: MainRoute.page, path: '/main'),
        AutoRoute(page: PermissionsRoute.page, path: '/permissions'),
      ];
    } else if (!_firstAppRun && !_permissionsGranted) {
      return [
        AutoRoute(page: MainRoute.page, path: '/main'),
        AutoRoute(page: PermissionsRoute.page, path: '/'),
      ];
    } else if (!_firstAppRun && _permissionsGranted) {
      return [
        AutoRoute(page: MainRoute.page, path: '/', children: [
          AutoRoute(page: HomeRoute.page, path: 'home'),
          AutoRoute(page: JournalRoute.page, path: 'journal'),
        ]),
      ];
    } else {
      return [
        AutoRoute(page: WelcomeRoute.page, path: '/'),
        AutoRoute(page: MainRoute.page, path: '/main'),
        AutoRoute(page: PermissionsRoute.page, path: '/permissions'),
      ];
    }
  }
}
