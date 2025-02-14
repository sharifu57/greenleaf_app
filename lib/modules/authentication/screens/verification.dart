import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';
import 'package:greenleaf_app/modules/authentication/providers/auth_provider.dart';
import 'package:greenleaf_app/shared/components/buttons/base_button.dart';
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
                              setState(() {
                                _otpController.text = value;
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
                                  print("=======tap resend code");
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

  _handleVerificationFormSubmit(
      BuildContext context, AuthProvider authProvider, otpNumber) {
    authProvider.validateOtp(phoneNumber!, otpNumber).then((success) => {
          if (success)
            {
              print("========otp verified successfully")
              // Navigator.pop(context);
            }
          else
            {print("========otp verification failed")}
        });
  }
}
