import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:greenleaf_app/shared/components/headers/header_text.dart';
import 'package:greenleaf_app/shared/utils/colors.dart';
import 'package:greenleaf_app/shared/utils/location.dart';
import 'package:standard_searchbar/old/standard_searchbar.dart';

class Home extends StatefulWidget {
  const Home({super.key, required Null Function(dynamic page) goToPage});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocationService _locationService = LocationService();
  String _location = "Fetching...";
  double _temperature = 0.0;
  String _weatherIcon = "";

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  List<String> searchResults = [];
  List<String> data = [
    'Apple',
    'Banana',
    'Orange',
    'Grapes',
    'Pineapple',
    'Mango',
    'Strawberry',
    'Blueberry',
    'Cherry',
    'Raspberry',
    'Watermelon',
    'Dragonfruit',
    'Papaya',
    'Peach',
    'Pear',
    'Lemon',
    'Lime',
    'Kiwi',
  ];

  Future<void> _requestLocation() async {
    try {
      final position = await _locationService.checkLocationPermission(context);
      print("User Location: ${position.latitude}, ${position.longitude}");

      // Get the place name from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        print("======plcemarks $placemarks");
        Placemark place = placemarks.first;

        String name = place.name ?? "Unknown";
        String administrativeArea =
            place.administrativeArea ?? "Unknown"; // Example: Dodoma Urban
        String subAdministrativeArea =
            place.subAdministrativeArea ?? "Unknown"; // Example: Dom-Makulu
        String country = place.country ?? "Unknown";
        String locationName = place.name ?? "Unknown";
        String address = "${place.locality}, ${place.country}";
        String adminArea = place.administrativeArea ?? "Unknown";
        // double temperature = await LocationService()
        //     .getTemperature(position.latitude, position.longitude);

        WeatherData weatherData = await LocationService().getWeatherData(
            position.latitude, position.longitude); // Fetch weather details

        setState(() {
          _location = "$locationName, $adminArea";
          _temperature = weatherData.temperature;
          _weatherIcon = weatherData.iconUrl;

          print("=======weather rlu $_weatherIcon");
        });

        print("Temperature: ${weatherData.temperature}");
        print("Weather Icon: ${weatherData.iconUrl}");

        setState(() {
          _location = "$locationName, $adminArea";
          _temperature = _temperature;
        });

        print("temperature: $_temperature");

        print("Place Name: $name");
        print("Administrative Area: $administrativeArea");
        print("Sub Administrative Area: $subAdministrativeArea");
        print("Country: $country");
        print("Current Place: $address");
      } else {
        print("No place found for the given coordinates.");
      }
    } catch (e) {
      print("Location Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: fullHeight,
          child: Column(
            children: [
              Container(
                height: 0.4 * fullHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      AppColors.primaryColor,
                      AppColors.tertiaryColor
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Home",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      Positioned(
                                        right: -3, // Adjust position
                                        top: -3, // Adjust position
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            '3', // Example count
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                GestureDetector(
                                  onTap: () {},
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        Icons.notifications_active_outlined,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      Positioned(
                                        right: -3,
                                        top: -3,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            '5', // Example count
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: _weatherIcon.isNotEmpty
                                        ? Image.network(_weatherIcon,
                                            width: 100, height: 100)
                                        : CircularProgressIndicator(),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: [
                                        Text("📍$_location",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "🌡️ Temperature: ${_temperature.toStringAsFixed(1)}°C",
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          child: StandardSearchBar(
                            width: 360,
                            suggestions: [
                              'apple',
                              'banana',
                              'melon',
                              'orange',
                              'pineapple',
                              'strawberry',
                              'watermelon'
                            ],
                            onChanged: (value) {
                              onQueryChanged(value);
                            },
                            onSubmitted: (value) {
                              // Handle search submission
                            },
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onQueryChanged(String query) {
    setState(() {
      searchResults = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
