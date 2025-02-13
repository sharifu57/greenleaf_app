import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:greenleaf_app/modules/authentication/screens/verification.dart';
import 'package:greenleaf_app/shared/utils/data_connection.dart';
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

  Future<bool> signUp(BuildContext context, String phoneNumber, String fullName) async {
    startLoading();
    const url = "${DataConnection.baseUrl}auth/signUp";

    final data = {
      "phoneNumber": phoneNumber,
      "fullName": fullName,
    };

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
        final fullName = response.data['fullName'];
        final phoneNumber = response.data['phoneNumber'];
        StorageService.storeData("fullName", fullName);
        StorageService.storeData("phoneNumber", phoneNumber);
        navigateAndReplace(context, Verificatio());
        stopLoading();
      }

      return true;
    } on DioException catch (e) {
      stopLoading();
      if (e.response != null) {
        _errorMessage =
            "Failed to sign in. Server returned ${e.response?.statusCode}";
      } else {
        _errorMessage =
            "Failed to sign in. Please check your network connection.";
      }
      return false;
    }
  }
}
