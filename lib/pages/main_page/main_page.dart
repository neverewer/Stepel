import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../router/router.gr.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
        animatePageTransition: false,
        physics: const NeverScrollableScrollPhysics(),
        routes: const [
          HomeRoute(),
          JournalRoute(),
          ProfileRoute(),
        ],
        builder: (context, child, _) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            body: child,
            extendBody: true,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white.withOpacity(0.9),
              showUnselectedLabels: false,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              currentIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
              items: const [
                BottomNavigationBarItem(label: 'Главная', icon: Icon(Icons.adjust)),
                BottomNavigationBarItem(label: 'Журнал', icon: Icon(Icons.wysiwyg)),
                BottomNavigationBarItem(label: 'Профиль', icon: Icon(Icons.person_outlined)),
              ],
            ),
          );
        });
  }
}
