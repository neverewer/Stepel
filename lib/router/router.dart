import 'package:auto_route/auto_route.dart';
import 'package:stepel/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes =>
      [AutoRoute(page: WelcomeRoute.page, path: '/'), AutoRoute(page: HomeRoute.page, path: '/home')];
}
