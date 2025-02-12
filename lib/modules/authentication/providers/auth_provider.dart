import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:greenleaf_app/shared/utils/data_connection.dart';

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

  Future<bool> signUp(String phoneNumber) async {
    startLoading();

    try {
      Response response = await dio.post('${DataConnection.baseUrl}/sign',
          data: {phoneNumber: phoneNumber});

      print("========response: $response");
      stopLoading();

      return true;
    } on DioException catch (e) {
      stopLoading();
      print("========error: $e");
      _errorMessage = "Failed to sign in. Please try again.";

      return false;
    }
  }
}
