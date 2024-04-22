import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/blocs/application_bloc.dart';
import 'package:dtuNavigation/models/markers_model.dart';
import 'package:dtuNavigation/screens/homePage/notifications_screen.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';
import 'package:dtuNavigation/utils/station_details_page.dart';

class LiveTrafficScreen extends StatefulWidget {
  LiveTrafficScreen({Key? key, void Function(int index)? onAddButtonTapped})
      : super(key: key);

  @override
  State<LiveTrafficScreen> createState() => _LiveTrafficScreenState();
}

class _LiveTrafficScreenState extends State<LiveTrafficScreen>
    with AutomaticKeepAliveClientMixin {
  String name = "";

  List<Marker> dtuMarkers = [];
  AutoGenerate markers = AutoGenerate(markers: []);
  late Marker closest;
  Uint8List? marketimages;
  List<String> images = ['assets/icons/location.png'];
  bool defined = false;
  bool popupEnlarged = false;
  AutoGenerate searchResults = AutoGenerate(markers: []);
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
    super.initState();
    getMarkerData();
    log("Live Traffic Screen");
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: NavBar(),
      appBar: _appBar(),
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
        child: Text('Live Traffic',
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
      child: Column(
        children: [
          (markers.markers.length > 10 &&
                  applicationBloc.currentLocation != null)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: markers.markers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StationDetails(
                                    origin: Marker(
                                      markerId: MarkerId("current"),
                                      position: LatLng(
                                          applicationBloc
                                              .currentLocation!.latitude,
                                          applicationBloc
                                              .currentLocation!.longitude),
                                    ),
                                    destination: dtuMarkers[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                  foregroundImage:
                                      AssetImage("assets/icons/location.png"),
                                ),
                                title:
                                    Text("${markers.markers[index].auxaddres}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )),
                                subtitle:
                                    Text("${markers.markers[index].address}"),
                                trailing: Text(
                                    "${(Geolocator.distanceBetween(applicationBloc.currentLocation!.latitude, applicationBloc.currentLocation!.longitude, dtuMarkers[index].position.latitude, dtuMarkers[index].position.longitude) / 1000).toStringAsFixed(2)} KM",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 0, 162, 103),
                                    )),
                                isThreeLine: true,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
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
                          applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude)));
                  markers.markers.sort((a, b) => Geolocator.distanceBetween(
                          double.parse(a.latitude),
                          double.parse(a.longitude),
                          applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude)
                      .compareTo(Geolocator.distanceBetween(
                          double.parse(b.latitude),
                          double.parse(b.longitude),
                          applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude)));
                  log("sorted");
                  isloading = false;
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

  Future<void> results(String value) async {}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
