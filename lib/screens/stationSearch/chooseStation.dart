import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/models/placesAutoComplete.dart';
import 'package:dtuNavigation/screens/homePage/notifications_screen.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';

import 'package:dtuNavigation/screens/stationSearch/waypointdetail.dart';

import '../../blocs/application_bloc.dart';
import '../../models/markers_model.dart';
import 'LocationListTile.dart';
import 'networkUtils.dart';

class ChooseStation extends StatefulWidget {
  double lat;
  double long;
  ChooseStation({required this.lat, required this.long, super.key});

  @override
  State<ChooseStation> createState() => _ChooseStationState();
}

class _ChooseStationState extends State<ChooseStation> {
  List<AutocompletePrediction> placePredictions = [];
  String name = "";

  List<Marker> dtuMarkers = [];
  AutoGenerate markers = AutoGenerate(markers: []);
  late Marker closest;
  Uint8List? marketimages;
  List<String> images = ['assets/icons/location.png'];
  bool defined = false;
  bool popupEnlarged = false;
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  LatLng destination = const LatLng(0, 0);
  bool functioncalled = true;
  bool firstTimeCamera = false;
  Marker currentMarker = Marker(markerId: const MarkerId("current"));
  late Marker destinationMarker;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController mapController;
  bool isloading = true;
  Uint8List markIcons = Uint8List(0);

  late ApplicationBloc applicationBloc;

  @override
  void initState() {
    getMarkerData();
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    super.initState();
  }

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
          child: Text('Choose station',
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
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: (markers.markers.isEmpty) ? 0 : 10,
              itemBuilder: (context, index) => LocationListTile(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaypointDetails(
                        origin: Marker(
                          markerId: MarkerId("current"),
                          position: LatLng(
                              applicationBloc.currentLocation!.latitude,
                              applicationBloc.currentLocation!.longitude),
                        ),
                        destination: Marker(
                          markerId: MarkerId('destination'),
                          position: LatLng(widget.lat, widget.long),
                        ),
                        waypoint: dtuMarkers[index],
                      ),
                    ),
                  );
                },
                distance: (Geolocator.distanceBetween(
                            dtuMarkers[index].position.latitude,
                            dtuMarkers[index].position.longitude,
                            applicationBloc.currentLocation!.latitude,
                            applicationBloc.currentLocation!.longitude) /
                        1000)
                    .toStringAsFixed(2),
                location: dtuMarkers[index].markerId.value,
              ),
            ),
          ),
          LocationListTile(
            press: () {},
            location: "",
            distance: "",
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

  getMarkerData() async {
    log('function called');
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('markers')
        .get()
        .then((response) => {
              markers = AutoGenerate.fromJson(response.docs[0].data()),
              log("${markers.markers.length}"),
              setState(() async {
                log('awaiting custom marker');
                {
                  log("custom marker set");
                  log("adding markers");
                  for (int i = 0; i < markers.markers.length; i++) {
                    dtuMarkers.add(
                      Marker(
                        markerId: MarkerId(markers.markers[i].auxaddres),
                        position: LatLng(
                            double.parse(markers.markers[i].latitude),
                            double.parse(markers.markers[i].longitude)),
                        onTap: () {},
                      ),
                    );
                  }
                }
                ;
                log("markers added");
                log("approaching sort");
                if (applicationBloc.currentLocation == null) {
                  applicationBloc.currentLocation =
                      await applicationBloc.setCurrentLocation();
                  log("current location set");
                }
                if (applicationBloc.currentLocation != null) {
                  log("enterd sorting");
                  dtuMarkers.sort((a, b) => Geolocator.distanceBetween(
                          a.position.latitude,
                          a.position.longitude,
                          applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude)
                      .compareTo(Geolocator.distanceBetween(
                          b.position.latitude,
                          b.position.longitude,
                          (applicationBloc.currentLocation!.latitude +
                                  widget.lat) /
                              2,
                          (applicationBloc.currentLocation!.longitude +
                                  widget.long) /
                              2)));

                  markers.markers.sort((a, b) => Geolocator.distanceBetween(
                          double.parse(a.latitude),
                          double.parse(a.longitude),
                          applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude)
                      .compareTo(Geolocator.distanceBetween(
                          double.parse(b.latitude),
                          double.parse(b.longitude),
                          (applicationBloc.currentLocation!.latitude +
                                  widget.lat) /
                              2,
                          (applicationBloc.currentLocation!.longitude +
                                  widget.long) /
                              2)));
                  log("sorted");
                  isloading = false;

                  for (int i = 0; i < markers.markers.length; i++) {
                    if (Geolocator.distanceBetween(
                                applicationBloc.currentLocation!.latitude,
                                applicationBloc.currentLocation!.longitude,
                                double.parse(markers.markers[i].latitude),
                                double.parse(markers.markers[i].longitude)) >=
                            Geolocator.distanceBetween(
                                applicationBloc.currentLocation!.latitude,
                                applicationBloc.currentLocation!.longitude,
                                (applicationBloc.currentLocation!.latitude +
                                        widget.lat) /
                                    2,
                                (applicationBloc.currentLocation!.longitude +
                                        widget.long) /
                                    2) &&
                        Geolocator.distanceBetween(
                                applicationBloc.currentLocation!.latitude,
                                applicationBloc.currentLocation!.longitude,
                                double.parse(markers.markers[i].latitude),
                                double.parse(markers.markers[i].longitude)) >=
                            Geolocator.distanceBetween(
                                double.parse(markers.markers[i].latitude),
                                double.parse(markers.markers[i].longitude),
                                (applicationBloc.currentLocation!.latitude +
                                        widget.lat) /
                                    2,
                                (applicationBloc.currentLocation!.longitude +
                                        widget.long) /
                                    2)) {
                    } else {
                      markers.markers.removeAt(i);
                      dtuMarkers.removeAt(i);
                    }
                  }
                  for (int i = 0; i < dtuMarkers.length; i++) {
                    log(dtuMarkers[i].markerId.value);
                  }
                }
                closest = dtuMarkers[0];
                setState(() {
                  defined = true;
                  log(dtuMarkers.length.toString());
                  log("closest ${closest.position.latitude}, ${closest.position.longitude} distance ${Geolocator.distanceBetween(closest.position.latitude, closest.position.longitude, applicationBloc.currentLocation!.latitude, applicationBloc.currentLocation!.longitude)}");
                });
              }),
            });
  }
}
