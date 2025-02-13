import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputForm extends StatefulWidget {
  final String labelText;
  final TextStyle labelStyle;
  final String hintText;
  final TextStyle hintStyle;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onSaved;
  final TextInputType keyBoardInputType;
  final bool obscureText;
  final String countryCode;
  final bool roundedBorder;
  final bool isFocusNode;
  final FocusNode? focusNode;
  final bool isPhoneInput;
  final IconData? prefixIcon;

  const InputForm(
      {super.key,
      required this.labelText,
      required this.labelStyle,
      required this.hintText,
      required this.hintStyle,
      required this.controller,
      required this.validator,
      required this.onSaved,
      required this.keyBoardInputType,
      this.obscureText = false,
      required this.countryCode,
      required this.roundedBorder,
      this.focusNode,
      this.isFocusNode = false,
      required this.isPhoneInput,
      this.prefixIcon});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: widget.isPhoneInput
          ? [
              LengthLimitingTextInputFormatter(9),
              FilteringTextInputFormatter.digitsOnly,
            ]
          : null,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyBoardInputType,
      obscureText: obscureText,
      focusNode: widget.isFocusNode ? widget.focusNode : null,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefixIcon: widget.isPhoneInput
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.countryCode,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              )
            : (widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 18,
                  )
                : null),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: _togglePasswordVisibility,
              )
            : null,
        border: widget.roundedBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              )
            : const UnderlineInputBorder(),
      ),
    );
  }
}
