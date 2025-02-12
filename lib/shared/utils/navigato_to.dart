import 'package:flutter/cupertino.dart';

void navigateAndReplace(BuildContext context, Widget widgetScreen) {
  // switch (routeName) {
  //   case 'introduction':
  //     screen = IntroductionScreen();
  //     break;

  //   default:
  //     // Add more cases as needed
  //     screen = IntroductionScreen();
  //     throw Exception('Unknown route: $routeName');
  // }

  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => widgetScreen));
}
