import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:dtuNavigation/screens/googleMapsScreen/googleMaps_screen.dart';
import 'package:dtuNavigation/screens/liveTraffic/liveTraffic.dart';
import 'package:dtuNavigation/screens/routePlanner/routePlanner_screen.dart';
import 'package:dtuNavigation/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../dashboard/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    DashboardScreen(),
    GoogleMapsPage(),
    const SettingsScreen(),
  ];

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);
  int maxCount = 5;

  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            DashboardScreen(
              onAddButtonTapped: onAddButtonTapped,
            ),
            // RoutePlannerScreen(
            //   onAddButtonTapped: onAddButtonTapped,
            // ),
            // LiveTrafficScreen(
            //   onAddButtonTapped: onAddButtonTapped,
            // ),
            GoogleMapsPage(onAddButtonTapped: onAddButtonTapped),
            SettingsScreen(onAddButtonTapped: onAddButtonTapped),
          ],
        ),
        extendBody: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: (screens.length <= maxCount)
            ? AnimatedNotchBottomBar(
              kIconSize: 10,
              kBottomRadius: 10,
                /// Provide NotchBottomBarController
                notchBottomBarController: _controller,
                color: Colors.white,
                showLabel: false,
                notchColor: Colors.white,

                /// restart app if you change removeMargins
                removeMargins: false,
                bottomBarWidth: 500,
                durationInMilliSeconds: 300,
                bottomBarItems: [
                  const BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home_filled,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.home_filled,
                      color: Color.fromARGB(255, 0, 255, 162),
                    ),
                    itemLabel: 'Home',
                  ),
                  // const BottomBarItem(
                  //   inActiveItem: Icon(
                  //     Icons.route_rounded,
                  //     color: Colors.blueGrey,
                  //   ),
                  //   activeItem: Icon(
                  //     Icons.route_rounded,
                  //     color: Color.fromARGB(255, 0, 255, 162),
                  //   ),
                  //   itemLabel: 'Route Planner',
                  // ),
                  // const BottomBarItem(
                  //   inActiveItem: Icon(
                  //     Icons.traffic_rounded,
                  //     color: Colors.blueGrey,
                  //   ),
                  //   activeItem: Icon(
                  //     Icons.traffic_rounded,
                  //     color: Color.fromARGB(255, 0, 255, 162),
                  //   ),
                  //   itemLabel: 'Live Traffic',
                  // ),
                  const BottomBarItem(
                    inActiveItem: Icon(
                      Icons.location_on,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 0, 255, 162),
                    ),
                    itemLabel: 'Maps Page',
                  ),

                  ///svg example
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.settings,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 0, 255, 162),
                    ),
                    itemLabel: 'Settings Page',
                  ),
                ],
                onTap: (index) {
                  /// perform action on tab change and to update pages you can update pages without pages
                  log('current selected index $index');
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
              )
            : null,
      ),
    );
  }

  bool onWillPop() {
    if (_pageController.page!.round() == _pageController.initialPage) {
      log('came to false');
      return false;
    } else {
      log('came to true');
      _pageController.animateToPage(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      _controller.jumpTo(0);
      return false;
    }
  }

  void onAddButtonTapped(int index) {
    _controller.jumpTo(index);
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
