import 'package:flutter/material.dart';
import 'package:greenleaf_app/shared/utils/colors.dart';

class BaseButton extends StatefulWidget {
  final String name;
  final bool isFullwidth;
  final VoidCallback onPressed;

  const BaseButton(
      {super.key,
      required this.name,
      required this.isFullwidth,
      required this.onPressed});

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: AppColors.primaryColor,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullwidth ? double.infinity : 12.2,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: widget.onPressed,
        child: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
