import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:toastification/toastification.dart';

class LocationService {
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
}
