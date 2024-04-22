import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/blocs/application_bloc.dart';
import 'package:dtuNavigation/models/markers_model.dart';
import 'package:dtuNavigation/screens/dashboard/utils/liveStationsWidget.dart';
import 'package:dtuNavigation/screens/homePage/notifications_screen.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';

class DashboardScreen extends StatefulWidget {
  void Function(int index)? onAddButtonTapped;
  DashboardScreen({Key? key, this.onAddButtonTapped}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
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
    log('initstate called');
    getMarkerData();
    log('initstate called 2');
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    log('dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: const NavBar(),
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
        child: Text('Dashboard',
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        Row(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            //   child: Text(
            //     "Featured",
            //     style: GoogleFonts.poppins(
            //       textStyle: const TextStyle(
            //         color: ui.Color.fromARGB(141, 80, 80, 80),
            //         fontSize: 11,
            //         fontWeight: FontWeight.w700,
            //         fontStyle: FontStyle.normal,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                "Places in DTU",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: ui.Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        (markers.markers.length > 10 && applicationBloc.currentLocation != null)
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.8 - 35,
                child: LiveStationsWidget(
                  markers: markers,
                  dtuMarker: dtuMarkers,
                  start: Marker(
                    markerId: MarkerId("current"),
                    position: LatLng(applicationBloc.currentLocation!.latitude,
                        applicationBloc.currentLocation!.longitude),
                  ),
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.38,
                child: Center(child: CircularProgressIndicator())),
        Spacer(),
      ]),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
