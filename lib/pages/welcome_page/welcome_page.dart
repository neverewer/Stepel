import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stepel/services/local_storage_service.dart';

import 'welcome_card1.dart';
import 'welcome_card2.dart';
import 'welcome_card3.dart';
import 'welcome_card4.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PageWidget(
                    pageController: _pageController,
                    onPageChanged: (index) => setState(() {
                          currentPageIndex = index;
                        })),
                PageIndicator(pageController: _pageController),
                NextButton(
                  pageController: _pageController,
                  currentPageIndex: currentPageIndex,
                ),
                const SkipButton(),
              ],
            )));
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.pageController, required this.currentPageIndex});
  final PageController pageController;
  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48.0,
        width: 340,
        decoration:
            const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 2, 173, 102), Colors.blue])),
        child: ElevatedButton(
          onPressed: () {
            currentPageIndex == 3
                ? {
                    LocalStorageService.instance.setFirstAppRun(false),
                    context.router.pushNamed('/permissions'),
                  }
                : {
                    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                  };
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
          child: Text(currentPageIndex == 3 ? 'Начать' : 'Далее'),
        ),
      ),
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: const Text('Пропустить',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              decoration: TextDecoration.underline,
            )),
        onPressed: () => {
              LocalStorageService.instance.setFirstAppRun(false),
              context.router.replaceNamed('/permissions'),
            });
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: 4,
      effect: ExpandingDotsEffect(
          activeDotColor: Colors.deepPurple, dotColor: Colors.deepPurple.shade100, dotHeight: 10, dotWidth: 10),
    );
  }
}

class PageWidget extends StatelessWidget {
  const PageWidget({super.key, required this.pageController, required this.onPageChanged});
  final PageController pageController;
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: PageView(
          controller: pageController,
          children: const [WelcomeCard1(), WelcomeCard2(), WelcomeCard3(), WelcomeCard4()],
          onPageChanged: (pageIndex) {
            onPageChanged(pageIndex);
          }),
    );
  }
}
