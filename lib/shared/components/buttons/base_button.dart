import 'package:flutter/material.dart';
import 'package:greenleaf_app/shared/utils/colors.dart';
import 'package:greenleaf_app/shared/utils/loader.dart';

class BaseButton extends StatefulWidget {
  final String name;
  final bool isFullwidth;
  final bool? isDisabled;
  final VoidCallback onPressed;

  const BaseButton({
    super.key,
    required this.name,
    required this.isFullwidth,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor:
          widget.isDisabled! ? AppColors.disabledColor : AppColors.primaryColor,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );

    return SizedBox(
      width: widget.isFullwidth ? double.infinity : 12.2,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: widget.isDisabled! ? null : widget.onPressed,
        child: widget.isDisabled!
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loader(),
                  SizedBox(width: 8), // Space between the loader and text
                  Text(
                    widget.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : Text(
                widget.name,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
