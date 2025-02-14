import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenleaf_app/modules/authentication/providers/auth_provider.dart';
import 'package:greenleaf_app/shared/components/buttons/base_button.dart';
import 'package:greenleaf_app/shared/components/forms/input_form.dart';
import 'package:greenleaf_app/shared/components/headers/header_text.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  final TextEditingController _phoneConteroller = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneFocusNode
        .dispose(); // Dispose of the focus node when the widget is disposed
    super.dispose();
  }

  ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                  HeaderText(title: "Account Details"),
                ],
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputForm(
                      isPhoneInput: false,
                      roundedBorder: false,
                      labelText: "Full Name",
                      labelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      hintText: "John Smith",
                      hintStyle:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      controller: _fullNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Your name is required";
                        }
                        return null;
                      },
                      onSaved: (value) {},
                      keyBoardInputType: TextInputType.text,
                      countryCode: "+255",
                      focusNode: _phoneFocusNode,
                      prefixIcon: Icons.person,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InputForm(
                      isPhoneInput: true,
                      roundedBorder: false,
                      labelText: "Phone Number",
                      labelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      hintText: "657******",
                      hintStyle:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      controller: _phoneConteroller,
                      validator: (value) {
                        if (value!.length < 9) {
                          return "Phone number should be at least 9 digits long";
                        }
                        if (value.isEmpty) {
                          return "Phone number is required";
                        }

                        if (value.startsWith("0")) {
                          return "Phone number should not start with 0";
                        }

                        return null;
                      },
                      onSaved: (value) {},
                      keyBoardInputType: TextInputType.phone,
                      countryCode: "+255",
                      focusNode: _phoneFocusNode,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: SizedBox(
                        child: RichText(
                          text: TextSpan(
                            text:
                                "The Application will send you an SMS with a Verification Code to proceed to next steps.",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: colorScheme(context).onSurface),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: BaseButton(
                        isFullwidth: true,
                        isDisabled: authProvider.isLoading,
                        name: "Sign In",
                        onPressed: () {
                          _formKey.currentState?.validate() ?? false
                              ? _handleFormSubmit(
                                  context,
                                  authProvider,
                                  _phoneConteroller.text,
                                  _fullNameController.text)
                              : null;
                        },
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

  void _handleFormSubmit(
      BuildContext context, AuthProvider authProvider, phoneNumber, fullName) {
    authProvider.signUp(context, phoneNumber, fullName).then((success) => {
          if (!success)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(authProvider.errorMessage),
                    backgroundColor: colorScheme(context).error),
              )
            }
          else
            {
              // Handle successful sign up, maybe navigate or show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authProvider.successMessage),
                  backgroundColor: colorScheme(context).primary,
                ),
              )
            }
        });
  }
}
