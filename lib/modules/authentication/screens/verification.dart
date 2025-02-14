import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';
import 'package:greenleaf_app/modules/authentication/providers/auth_provider.dart';
import 'package:greenleaf_app/shared/components/buttons/base_button.dart';
import 'package:greenleaf_app/shared/components/dialogs/show_dialog.dart';
import 'package:greenleaf_app/shared/components/headers/header_text.dart';
import 'package:greenleaf_app/shared/utils/constants.dart';
import 'package:greenleaf_app/shared/utils/preference.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification>
    with TickerProviderStateMixin {
  final TextEditingController _otpController = TextEditingController();
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    String? phoneNumber = await StorageService.retrieveData("phoneNumber");

    print("=====phone number $phoneNumber");

    setState(() {
      this.phoneNumber = phoneNumber!;
    });
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
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 70.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(title: "Verify your"),
                  HeaderText(title: "Phone Number"),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    child: Text(
                        "Enter the 6-digit code sent to this phone number"),
                  ),
                  SizedBox(
                    child: Text(
                      "$phoneNumber",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          VerificationCodeField(
                            length: 6,
                            onFilled: (value) => {
                              print("=======value $value"),
                              setState(() {
                                _otpController.text = value;
                                _validateOTP();
                              })
                            },
                            size: Size(30, 60),
                            spaceBetween: 30,
                            matchingPattern: RegExp(r'^\d+$'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  showCustomDialog(
                                      context: context,
                                      title: "Resend Code",
                                      content:
                                          "Are you sure you want to send new verification code to $phoneNumber ?.",
                                      onConfirm: () {
                                        authProvider
                                            .resendVerificationCode(
                                                phoneNumber!)
                                            .then((success) {
                                          if (!success) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(authProvider
                                                      .errorMessage),
                                                  backgroundColor:
                                                      colorScheme(context)
                                                          .error),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(authProvider
                                                    .successMessage),
                                                backgroundColor:
                                                    colorScheme(context)
                                                        .primary,
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      });
                                },
                                child: Text("Resend Code via SMS"),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 40.h,
                            child: BaseButton(
                              isFullwidth: true,
                              isDisabled: authProvider.isLoading,
                              name: "Verify Code",
                              onPressed: () {
                                _formKey.currentState?.validate() ?? false
                                    ? _handleVerificationFormSubmit(
                                        context,
                                        authProvider,
                                        _otpController.text,
                                      )
                                    : null;
                              },
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateOTP() {
    print("=======validateOTP =====");
    if (_otpController.text.length < 6 ||
        !_otpController.text.contains(RegExp(r'^\d+$'))) {
      setState(() {
        _errorMessage = "Invalid OTP. Enter a 6-digit number.";
      });
    } else {
      setState(() {
        _errorMessage = null;
      });

      // Proceed with verification
      print("Valid OTP: ${_otpController.text}");
    }
  }

  void _handleVerificationFormSubmit(
      BuildContext context, AuthProvider authProvider, String otpNumber) {
    authProvider.validateOtp(phoneNumber!, otpNumber).then((success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? authProvider.successMessage
              : authProvider.errorMessage),
          backgroundColor: success
              ? colorScheme(context).primary
              : colorScheme(context).error,
        ),
      );
    });
  }
}
