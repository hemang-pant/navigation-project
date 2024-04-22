import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dtuNavigation/models/placesAutoComplete.dart';
import 'package:dtuNavigation/screens/homePage/notifications_screen.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';
import 'package:dtuNavigation/screens/stationSearch/LocationListTile.dart';
import 'package:dtuNavigation/screens/stationSearch/chooseStation.dart';
import 'package:dtuNavigation/screens/stationSearch/networkUtils.dart';

class StationSearch extends StatefulWidget {
  const StationSearch({super.key});

  @override
  State<StationSearch> createState() => _StationSearchState();
}

class _StationSearchState extends State<StationSearch> {
  List<AutocompletePrediction> placePredictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text('Search destination',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                onChanged: (value) {
                  placesAutoComplete(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "where to?",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTile(
                  distance: '',
                  press: () async {
                    LatLng? temp = await placePredictions[index].getLatLong();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseStation(
                            lat: temp!.latitude, long: temp.longitude),
                      ),
                    );
                  },
                  location: placePredictions[index].description!),
            ),
          ),
          LocationListTile(
            distance: '',
            press: () {},
            location: "",
          ),
        ],
      ),
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
        setState(() {
          placePredictions = result.predictions!;
        });
        print(result.predictions![0].placeId);
      }
    }
  }
}
