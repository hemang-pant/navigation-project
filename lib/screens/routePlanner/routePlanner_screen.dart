import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import 'package:dtuNavigation/models/placesAutoComplete.dart';
import 'package:dtuNavigation/screens/googleMapsScreen/googleMaps_screen.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';
import 'package:dtuNavigation/screens/stationSearch/StationSearch.dart';
import 'package:dtuNavigation/screens/stationSearch/networkUtils.dart';

import '../homePage/notifications_screen.dart';

class RoutePlannerScreen extends StatefulWidget {
  late void Function(int index) onAddButtonTapped;
  RoutePlannerScreen({Key? key, void Function(int index)? onAddButtonTapped})
      : super(key: key);

  @override
  State<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RoutePlannerScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _appBar(),
      drawer: NavBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            );
          },
          icon: Icon(
            Icons.notifications,
            color: Colors.black,
          ),
        ),
      ],
      leading: Builder(
        builder: (context) => CircleAvatar(
          backgroundColor: Color.fromARGB(255, 0, 255, 162),
          child: IconButton(
            icon: Icon(Icons.menu_rounded),
            color: Colors.black,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      backgroundColor: ui.Color.fromARGB(171, 188, 255, 255),
      title: Center(
        child: Text('Route Planner',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
      ),
      elevation: 0,
    );
  }

  _body() {
    return Container(
      color: ui.Color.fromARGB(171, 188, 255, 255),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: TextField(
                enableInteractiveSelection: false,
                enabled: false,
                controller: TextEditingController(
                  text: "Your Location",
                ),
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: TextStyle(
                  decorationColor: Colors.black,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: "Your Location",
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StationSearch()));
                },
                child: TextField(
                  enabled: false,
                  onChanged: (value) {
                    placesAutoComplete(value);
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StationSearch()));
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "where to?",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Divider(
            thickness: 0,
            color: Color.fromARGB(0, 166, 166, 166),
          ),
        ),
        Text(
          'Plan Your Trips',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              elevation: 5,
              minimumSize: const Size(240, 50),
              maximumSize: const Size(240, 50),
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: const Color.fromARGB(255, 0, 255, 162),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StationSearch()));
            },
            child: Center(
              child: Text(
                "Battery Saver Mode",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
        Text(
          "When battery is less than 50% ",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: ui.Color.fromARGB(141, 80, 80, 80),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              elevation: 5,
              minimumSize: const Size(240, 50),
              maximumSize: const Size(240, 50),
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: const Color.fromARGB(255, 0, 255, 162),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StationSearch()));
            },
            child: Center(
              child: Text(
                "Time Saver Mode",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
        Text(
          "when you're in a hurry!!",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: ui.Color.fromARGB(141, 80, 80, 80),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              elevation: 5,
              minimumSize: const Size(240, 50),
              maximumSize: const Size(240, 50),
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: const Color.fromARGB(255, 0, 255, 162),
            ),
            onPressed: () {
              Navigator.pushNamed(context, GoogleMapsPage.routeName);
            },
            child: Center(
              child: Text(
                "Map View",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          "See all the charing stations at a glance ",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: ui.Color.fromARGB(141, 80, 80, 80),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Spacer(),
      ]),
    );
  }

  Future<void> placesAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": query,
      "key": "AIzaSyCOzoP4mN1S1DuNtDbjOwjRlbSimSSEt10",
    });
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        print(result.predictions![0].placeId);
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
