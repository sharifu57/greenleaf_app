import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';
import 'package:greenleaf_app/modules/authentication/providers/auth_provider.dart';
import 'package:greenleaf_app/modules/authentication/screens/sign_up.dart';
import 'package:greenleaf_app/shared/components/buttons/base_button.dart';
import 'package:greenleaf_app/shared/components/dialogs/show_dialog.dart';
import 'package:greenleaf_app/shared/components/headers/header_text.dart';
import 'package:greenleaf_app/shared/utils/constants.dart';
import 'package:greenleaf_app/shared/utils/navigato_to.dart';
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
  bool? _isCorrect;
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
                height: 20.h,
              ),
              SizedBox(
                height: 80.h,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      navigateAndReplace(context, SignUp());
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Back",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _errorMessage!,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
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
                                _validateOTP();
                                if (_errorMessage == null &&
                                    _isCorrect == true) {
                                  _formKey.currentState?.validate() ?? false
                                      ? _handleVerificationFormSubmit(
                                          context,
                                          authProvider,
                                          _otpController.text,
                                        )
                                      : null;
                                }
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
    String otp = _otpController.text.trim();

    if (otp.isEmpty) {
      setState(() {
        _errorMessage = "OTP cannot be empty.";
        _isCorrect = false;
      });
    } else if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
      setState(() {
        _errorMessage = "Invalid OTP. Enter a 6-digit number.";
        _isCorrect = false;
      });
    } else {
      setState(() {
        _errorMessage = null;
        _isCorrect = true;
      });
      print("Valid OTP: $otp");
    }
  }

  void _handleVerificationFormSubmit(
      BuildContext context, AuthProvider authProvider, String otpNumber) {
    authProvider.validateOtp(context, phoneNumber!, otpNumber).then((success) {
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
