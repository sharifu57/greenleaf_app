import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenleaf_app/modules/authentication/providers/auth_provider.dart';
import 'package:greenleaf_app/shared/providers/app_provider.dart';
import 'package:greenleaf_app/shared/screens/splash_screen.dart';
import 'package:greenleaf_app/shared/utils/color_schemes.g.dart';
import 'package:greenleaf_app/shared/utils/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  setUpWindow();
  await ScreenUtil.ensureScreenSize();
  runApp(const GreenLeafApp());
}

void setUpWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
  }
}

class GreenLeafApp extends StatefulWidget {
  const GreenLeafApp({super.key});

  @override
  State<GreenLeafApp> createState() => _GreenLeafAppState();
}

class _GreenLeafAppState extends State<GreenLeafApp> {
  ThemeMode? _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeWithFont(ThemeData theme) => theme.copyWith();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            navigatorKey: Constants.globalAppKey,
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            themeMode: _themeMode,
            theme: themeWithFont(
              ThemeData(
                useMaterial3: true,
                fontFamily: 'NotoSans',
                colorScheme: lightColorScheme,
              ),
            ),
            darkTheme: themeWithFont(
              ThemeData(
                useMaterial3: true,
                fontFamily: 'NotoSans',
                colorScheme: darkColorScheme,
              ),
            ),
          );
        },
      ),
    );
  }
}
