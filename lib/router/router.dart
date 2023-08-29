import 'package:stepel/imports.dart';

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
        AutoRoute(page: MainRoute.page, path: '/main', children: [
          AutoRoute(page: HomeRoute.page, path: 'home'),
          AutoRoute(page: JournalRoute.page, path: 'journal'),
          AutoRoute(page: ProfileRoute.page, path: 'profile'),
        ]),
        AutoRoute(page: PermissionsRoute.page, path: '/permissions')
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
          AutoRoute(page: ProfileRoute.page, path: 'profile')
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
