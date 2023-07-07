import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stepel/pages/welcome_card1.dart';
import 'package:stepel/pages/welcome_card2.dart';
import 'package:stepel/pages/welcome_card3.dart';
import 'package:stepel/pages/welcome_card4.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 550,
                  child: PageView(
                    controller: _controller,
                    children: const [
                      WelcomeCard1(),
                      WelcomeCard2(),
                      WelcomeCard3(),
                      WelcomeCard4()
                    ],
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: ExpandingDotsEffect(
                      activeDotColor: Colors.deepPurple,
                      dotColor: Colors.deepPurple.shade100,
                      dotHeight: 10,
                      dotWidth: 10),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 48.0,
                    width: 340,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 2, 173, 102),
                      Colors.blue
                    ])),
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text('Next'),
                    ),
                  ),
                ),
                const Text('Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      decoration: TextDecoration.underline,
                    ))
              ],
            )));
  }
}
