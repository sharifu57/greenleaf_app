import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setUpWindow();
  runApp(const MyApp());
}

const double windowWidth = 400;
const double windowHeight = 800;

void setUpWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    // setWindowTitle('Provider Demo');
    // setWindowMinSize(const Size(windowWidth, windowHeight));
    // setWindowMaxSize(const Size(windowWidth, windowHeight));
    // getCurrentScreen().then((screen) {
    //   setWindowFrame(Rect.fromCenter(
    //     center: screen!.frame.center,
    //     width: windowWidth,
    //     height: windowHeight,
    //   ));
    // });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Text('Home'),
    );

    // return MultiProvider(
    //   providers: [],
    //   child: Text("Home"),
    // );
  }
}
