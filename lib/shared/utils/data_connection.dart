import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DataConnection extends ChangeNotifier {
  late Dio dio;

  static const String serverUrl = "http://192.168.1.198:8085";

  static const String baseUrl = '$serverUrl/api/v1/';
}
