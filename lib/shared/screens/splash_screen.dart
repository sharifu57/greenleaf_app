import 'package:flutter/material.dart';
import 'package:greenleaf_app/modules/authentication/screens/sign_up.dart';
import 'package:greenleaf_app/modules/authentication/screens/verification.dart';
import 'package:greenleaf_app/modules/home/screens/home_page.dart';
import 'package:greenleaf_app/shared/screens/app_logo.dart';
import 'package:greenleaf_app/shared/screens/intro_screen.dart';
import 'package:greenleaf_app/shared/utils/location.dart';
import 'package:greenleaf_app/shared/utils/navigato_to.dart';
import 'package:greenleaf_app/shared/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocationService _locationService = LocationService();
  @override
  void initState() {
    init();
    _requestLocation();
    super.initState();
  }

  void init() async {
    bool? isAuthenticated =
        await StorageService.retrieveData("isAuthenticated");

    await Future.delayed(const Duration(seconds: 3));

    if (isAuthenticated != true) {
      navigateAndReplace(context, HomePage());
    } else {
      navigateAndReplace(context, IntroductionScreen());
    }

    if (!mounted) return;
  }

  Future<void> _requestLocation() async {
    try {
      final position = await _locationService.checkLocationPermission(context);
      print("User Location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Location Error: $e");
    }
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
