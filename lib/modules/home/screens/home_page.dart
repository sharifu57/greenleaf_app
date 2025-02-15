import 'package:flutter/material.dart';
import 'package:greenleaf_app/modules/home/screens/account.dart';
import 'package:greenleaf_app/modules/home/screens/crop_care.dart';
import 'package:greenleaf_app/modules/home/screens/feed.dart';
import 'package:greenleaf_app/modules/home/screens/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    var pages = [
      Home(goToPage: (page) {
        setState(() {
          currentPageIndex = page;
        });
      }),
      Feed(),
      CropCare(),
      Account()
    ];
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(
            width: 0.05,
          ),
        )),
        child: NavigationBar(
            elevation: 20,
            height: 55,
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.notifications,
                  size: 18,
                ),
                icon: Icon(Icons.notifications_none_outlined),
                label: 'Notifications',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.notifications,
                  size: 18,
                ),
                icon: Icon(Icons.notifications_none_outlined),
                label: 'Notifications',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.notifications,
                  size: 18,
                ),
                icon: Icon(Icons.notifications_none_outlined),
                label: 'Notifications',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.notifications,
                  size: 18,
                ),
                icon: Icon(Icons.notifications_none_outlined),
                label: 'Notifications',
              ),
            ]),
      ),
    );
  }
}
