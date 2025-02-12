import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenleaf_app/shared/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  bool onLastPage = false;

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: AppColors.primaryColor,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: fullHeight,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: fullHeight / 1.2,
                padding: const EdgeInsets.all(20),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      onLastPage = (index == 2);
                    });
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
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        type: WormType.thin,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            if (onLastPage) {
                              _pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        child: TextButton(
                      style: flatButtonStyle,
                      onPressed: () {},
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pageOne(context) {
    final fullHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: fullHeight / 11),
          Column(
            children: [
              const Text(
                'Control',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const Text(
                'Your Crops!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: fullHeight / 2,
            child: SizedBox(
              width: 400,
              height: 400,
              child: SvgPicture.asset(
                'assets/images/agr.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Take control of your products and crops on each day to oversee the problem which could.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pageTwo(context) {
    final fullHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: fullHeight / 11),
          Column(
            children: [
              const Text(
                'Sell',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const Text(
                'Your Crops!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: fullHeight / 2,
            child: SizedBox(
              width: 300,
              height: 300,
              child: SvgPicture.asset(
                'assets/images/seed.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Take control of your products and crops on each day to oversee the problem which could.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pageThree(context) {
    return const Center(child: Text('Page Three'));
  }
}
