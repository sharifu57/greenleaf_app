import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DataConnection extends ChangeNotifier {
  late Dio dio;

  static const String serverUrl = "http://localhost:8008";

  static const String baseUrl = '$serverUrl/api/v1/';
}
