import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenleaf_app/shared/components/forms/input_form.dart';
import 'package:greenleaf_app/shared/components/headers/header_text.dart';
import 'package:greenleaf_app/shared/utils/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _phoneConteroller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneFocusNode
        .dispose(); // Dispose of the focus node when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(title: "What's your"),
                  HeaderText(title: "Phone Number"),
                ],
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputForm(
                      roundedBorder: false,
                      labelText: "Phone Number",
                      labelStyle: TextStyle(fontSize: 12),
                      hintText: "Enter Phone Number",
                      hintStyle: TextStyle(fontSize: 13),
                      controller: _phoneConteroller,
                      validator: (value) {
                        if (value!.length < 10) {
                          return "Phone number should be at least 10 digits long";
                        }
                        return null;
                      },
                      onSaved: (value) {},
                      keyBoardInputType: TextInputType.phone,
                      countryCode: "+255", // Example: Tanzania country code
                      focusNode: _phoneFocusNode, // Add focusNode here
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: SizedBox(
                        child: RichText(
                          text: TextSpan(
                            text:
                                "The Application will send you an SMS with a Verification Code to proceed to next steps.",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
