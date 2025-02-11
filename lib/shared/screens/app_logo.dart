import 'package:flutter/material.dart';

class AppLogo extends StatefulWidget {
  final double? height;
  final double? width;
  const AppLogo({super.key, this.height, this.width});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Center(
          // child: Image.asset(
          //   'assets/images/ic_launcher.png',
          // ),
          child: Text('logo')),
    );
  }
}
