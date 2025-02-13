import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }
}
