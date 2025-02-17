import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:greenleaf_app/shared/utils/constants.dart';
import 'package:location/location.dart' as loc;
import 'package:toastification/toastification.dart';

class WeatherData {
  final double temperature;
  final String iconUrl;
  final String description;

  WeatherData(
      {required this.temperature,
      required this.iconUrl,
      required this.description});
}

class LocationService {
  final String apiKey = Constants.weatherKey;
  final loc.Location location = loc.Location();

  /// Request location permission
  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == loc.PermissionStatus.granted;
  }

  /// Check and prompt user to enable GPS
  Future<bool> checkAndEnableGPS(BuildContext context) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      bool result = await location.requestService();
      if (!result) {
        _showLocationDialog(
            context, "GPS is required", "Please enable GPS to continue.");
        return false;
      }
    }
    return true;
  }

  /// Get the current location
  Future<geo.Position> checkLocationPermission(BuildContext context) async {
    bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (!serviceEnabled) {
      bool gpsEnabled = await checkAndEnableGPS(context);
      if (!gpsEnabled) throw 'GPS is required!';
    }

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        toastification.show(
          title: Text('Please allow location permission'),
          autoCloseDuration: const Duration(seconds: 5),
        );
        await geo.Geolocator.openAppSettings();
        throw 'Failed to allow location';
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      _showLocationDialog(context, "Permission Required",
          "Location permission is permanently denied. Please enable it from settings.");
      return Future.error('Location permission denied permanently.');
    }

    return await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
  }

  /// Show a dialog to enable location
  void _showLocationDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                geo.Geolocator.openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestLocation() async {
    try {
      geo.Position position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String locationName = place.name ?? "Unknown";
        String adminArea = place.administrativeArea ?? "Unknown";
        String country = place.country ?? "Unknown";

        print("📍 Location: $locationName, $adminArea, $country");

        // Get Temperature
        // double temperature =
        //     await getTemperature(position.latitude, position.longitude);
        // print("🌡️ Temperature: ${temperature.toStringAsFixed(1)}°C");
      }
    } catch (e) {
      print("Location Error: $e");
    }
  }

  // Future<WeatherData> getTemperature(double lat, double lon) async {
  //   String url =
  //       "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";

  //   Dio dio = new Dio();
  //   final response = await dio.get(url);

  //   print("response: $response");

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = response.data;
  //     double temperature = data["main"]["temp"];
  //     return temperature;
  //   } else {
  //     throw Exception("Failed to fetch weather data");
  //   }
  // }

  Future<WeatherData> getWeatherData(double lat, double lon) async {
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";

    Dio dio = Dio();
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      double temperature = data["main"]["temp"];

      String iconCode =
          data["weather"][0]["icon"]; // Extract the weather icon code
      String iconUrl =
          "https://openweathermap.org/img/wn/$iconCode@2x.png"; // OpenWeatherMap image URL
      String description = data["weather"][0]["description"];

      return WeatherData(
          temperature: temperature, iconUrl: iconUrl, description: description);
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }
}
