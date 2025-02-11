import 'package:flutter/material.dart';
import 'package:greenleaf_app/modules/authentication/screens/sign_in.dart';
import 'package:greenleaf_app/shared/screens/app_logo.dart';
import 'package:greenleaf_app/shared/screens/intro_screen.dart';
import 'package:greenleaf_app/shared/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  void init() async {
    await setupPreferences(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user = sharedPreferences.getString("auth_user");

    // if (user != null) {
    //   Navigator.pushReplacement(
    //       // ignore: use_build_context_synchronously
    //       context,
    //       MaterialPageRoute(
    //           settings: const RouteSettings(name: '/'),
    //           builder: (context) => IntroductionScreen()));
    // } else {
    //   Navigator.pushReplacement(
    //       // ignore: use_build_context_synchronously
    //       context,
    //       MaterialPageRoute(
    //           settings: const RouteSettings(name: '/'),
    //           builder: (context) => IntroductionScreen()));
    // }

    if (!mounted) return;

    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      child: Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(20),
          child: AppLogo(),
        ),
      ),
    );
  }
}
