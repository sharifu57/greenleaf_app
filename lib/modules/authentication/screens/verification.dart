import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenleaf_app/shared/components/headers/header_text.dart';
import 'package:greenleaf_app/shared/utils/preference.dart';

class Verificatio extends StatefulWidget {
  const Verificatio({super.key});

  @override
  State<Verificatio> createState() => _VerificatioState();
}

class _VerificatioState extends State<Verificatio> {
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
                    child: Text("$phoneNumber"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
