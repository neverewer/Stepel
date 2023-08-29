import 'package:stepel/imports.dart';
import 'package:stepel/pages/info_page/Info_card2.dart';
import 'package:stepel/pages/info_page/info_card1.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        height: 400,
        width: double.infinity,
        child: DecoratedBox(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.1,
                  ),
                ]),
            child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15, left: 30, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: PageWidget(
                      pageController: _pageController,
                      onPageChanged: (pageIndex) {
                        setState(() {
                          currentPageIndex = pageIndex;
                        });
                      },
                    )),
                    const SizedBox(height: 20),
                    NextButton(pageController: _pageController, currentPageIndex: currentPageIndex)
                  ],
                ))),
      ),
    ));
  }
}

class PageWidget extends StatelessWidget {
  const PageWidget({super.key, required this.pageController, required this.onPageChanged});
  final PageController pageController;
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (pageIndex) {
        onPageChanged(pageIndex);
      },
      children: const [InfoCard1(), InfoCard2()],
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.pageController, required this.currentPageIndex});
  final PageController pageController;
  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        child: TextButton(
          onPressed: () {
            currentPageIndex == 1
                ? {Navigator.pop(context)}
                : {
                    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                  };
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blue.withOpacity(0.2)),
          ),
          child: Text(currentPageIndex == 1 ? 'ОК' : 'Далее'),
        ));
  }
}
