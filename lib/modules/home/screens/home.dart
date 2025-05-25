import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  List<String> carouselImages = [
    "https://source.unsplash.com/800x400/?nature",
    "https://source.unsplash.com/800x400/?weather",
    "https://source.unsplash.com/800x400/?sunny",
    "https://source.unsplash.com/800x400/?rainy",
    "https://source.unsplash.com/800x400/?cloudy"
  ];

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  Future<void> _requestLocation() async {
    try {
      final position = await _locationService.checkLocationPermission(context);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String locationName = place.name ?? "Unknown";
        String adminArea = place.administrativeArea ?? "Unknown";

        WeatherData weatherData = await _locationService.getWeatherData(
            position.latitude, position.longitude);

        setState(() {
          _location = "$locationName, $adminArea";
          _temperature = weatherData.temperature;
          _weatherIcon = weatherData.iconUrl;
        });
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
                height: 0.2 * fullHeight,
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
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Home",
                            style: TextStyle(
                                fontSize: 15.sp,
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
                                    Icon(Icons.shopping_cart_rounded,
                                        color: Colors.white, size: 22),
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
                                          '3',
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
                                    Icon(Icons.notifications_active_outlined,
                                        color: Colors.white, size: 22),
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
                                          '5',
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
                      SizedBox(height: 30.h),
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
                          onSubmitted: (value) {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // _buildCarouselSlider(),
             
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.h,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: carouselImages.map((imageUrl) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageUrl.isEmpty
              ? Text("Loading...")
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        );
      }).toList(),
    );
  }

  Widget _buildWeatherInfo() {
    return Column(
      children: [
        Text(
          "Current Weather in $_location",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        _weatherIcon.isNotEmpty
            ? Image.network(_weatherIcon, width: 80.w, height: 80.h)
            : SizedBox.shrink(),
        SizedBox(height: 5.h),
        Text(
          "${_temperature.toStringAsFixed(1)}°C",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void onQueryChanged(String query) {
    setState(() {});
  }
}
