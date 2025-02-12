import 'package:flutter/material.dart';
import 'package:greenleaf_app/modules/authentication/screens/sign_up.dart';
import 'package:greenleaf_app/shared/screens/app_logo.dart';
import 'package:greenleaf_app/shared/screens/intro_screen.dart';
import 'package:greenleaf_app/shared/utils/navigato_to.dart';
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

    await Future.delayed(const Duration(seconds: 3));

    if (user != null) {
      navigateAndReplace(context, IntroductionScreen());
    } else {
      navigateAndReplace(context, SignUp());
    }

    if (!mounted) return;
  }

  ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).surface,
      body: Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: colorScheme(context).surface,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(20),
          child: AppLogo(),
        ),
      ),
    );
  }
}
