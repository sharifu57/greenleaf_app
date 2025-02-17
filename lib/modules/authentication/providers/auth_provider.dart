import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:greenleaf_app/modules/authentication/screens/verification.dart';
import 'package:greenleaf_app/modules/home/screens/home_page.dart';
import 'package:greenleaf_app/config/data_connection.dart';
import 'package:greenleaf_app/shared/utils/navigato_to.dart';
import 'package:greenleaf_app/shared/utils/preference.dart';

class AuthProvider with ChangeNotifier {
  Dio dio = Dio();

  String _errorMessage = "";
  String _successMessage = "";
  bool _isLoading = false;

  late DataConnection _dataConnection;

  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _dataConnection = DataConnection();
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signUp(
      BuildContext context, String phoneNumber, String fullName) async {
    startLoading();
    const url = "${DataConnection.baseUrl}auth/signUp";

    final String phoneNumberCode = "255$phoneNumber";

    final data = {
      "phoneNumber": phoneNumberCode,
      "fullName": fullName,
    };

    print("=========submit data: $data");

    try {
      await Future.delayed(const Duration(seconds: 2));
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        _successMessage = "Successfully Created Account.";
        final fullName = response.data?['data']?['fullName'];
        final phoneNumber = response.data?['data']?['phoneNumber'];
        StorageService.storeData("fullName", fullName);
        StorageService.storeData("phoneNumber", phoneNumber);
        navigateAndReplace(context, Verification());
        stopLoading();
      }

      return true;
    } on DioException catch (e) {
      stopLoading();
      if (e.response != null) {
        _errorMessage = "Failed to sign up. ${e.response?.data['message']}";
      } else {
        _errorMessage =
            "Failed to sign in. Please check your network connection.";
      }
      return false;
    }
  }

  Future<bool> validateOtp(
      BuildContext context, String phoneNumber, String otp) async {
    startLoading();
    const url = "${DataConnection.baseUrl}auth/validateOTP";
    final payload = {
      "phoneNumber": phoneNumber,
      "otp": otp,
    };

    try {
      await Future.delayed(const Duration(seconds: 2));
      Response response = await dio.post(
        url,
        data: jsonEncode(payload),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        _successMessage = "OTP verified successfully.";
        final isAuthenticated = response.data?['data']?['authenticated'];
        StorageService.storeData("isAuthenticated", isAuthenticated);
        navigateAndReplace(context, HomePage());
        stopLoading();
        return true;
      }

      stopLoading();
      return true;
    } on DioException catch (e) {
      stopLoading();
      if (e.response != null) {
        print("=======error ${e.response}");
        _errorMessage = "Failed to verify OTP. ${e.response?.data['message']}";
      } else if (e.response!.statusCode == 404) {
        _errorMessage = "Failed to verify OTP. Please try again later.";
      } else {
        _errorMessage =
            "Failed to verify OTP. Please check your network connection.";
      }

      stopLoading();
      return false;
    }
  }

  Future<bool> resendVerificationCode(String phoneNumber) async {
    startLoading();

    try {
      const url = "${DataConnection.baseUrl}auth/regenerateOTP";

      final payload = {"phoneNumber": phoneNumber};

      Response response = await dio.post(
        url,
        data: jsonEncode(payload),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      print("=======regenerate response $response");

      if (response.statusCode == 200) {
        _successMessage =
            "New OTP has been sent to this phone number $phoneNumber.";
        stopLoading();
        return true;
      }

      stopLoading();
      return true;
    } on DioException catch (e) {
      startLoading();
      if (e.response != null) {
        _errorMessage = "Failed to regenerate OTP. Please try again later.";
      }
    }

    stopLoading();
    return false;
  }
}
