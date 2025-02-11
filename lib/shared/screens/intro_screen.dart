import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final int _currentPage = 0;
  bool on_last_page = false;

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SizedBox(
        height: fullHeight,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: fullHeight / 2,
                padding: EdgeInsets.all(20),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => {
                    setState(() {
                      on_last_page = (index == 2);
                    })
                  },
                  children: [
                    pageOne(context),
                    pageTwo(context),
                    pageThree(context)
                  ],
                ),
              ),
              Container(
                alignment: const Alignment(0, 1),
                height: fullHeight / 1.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => {_pageController.jumpTo(2)},
                      child: Text("M"),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        type: WormType.thin,
                      ),
                    ),
                    on_last_page
                        ? GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: const Text(""),
                          )
                        : GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                            child: Text("G"),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageOne(context) {
    return SizedBox(
      child: SizedBox(
        child: Column(
          children: [
            Expanded(
              // child: Lottie.asset(
              //   'assets/img/img2.json',
              //   repeat: true,
              //   fit: BoxFit.contain,
              // ),
              child: Text("Hello 1"),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Column(
                children: [
                  Text(
                    'Find Opportunities',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  Column(
                    children: [
                      Text('Get notified every time a new project is created'),
                      Text('and be the first one to apply for it.'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pageTwo(context) {
    return Container(
      child: Center(
        child: Text('Page Two'),
      ),
    );
  }

  Widget pageThree(context) {
    return Container(
      child: Center(
        child: Text('Page Three'),
      ),
    );
  }
}
