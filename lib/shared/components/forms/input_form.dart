import 'package:flutter/material.dart';

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
  final FocusNode focusNode;

  const InputForm({
    super.key,
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
    required this.focusNode,
  });

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
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyBoardInputType,
      obscureText: obscureText,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefixIcon: Padding(
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
        ),
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
