import 'dart:developer';
import 'package:html/parser.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dtuNavigation/blocs/application_bloc.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dtuNavigation/screens/qrCodeScreen/qrCodeScreen.dart';
import 'package:dtuNavigation/services/firebase_auth_methods.dart';
import 'dart:convert' as convert;

import 'package:dtuNavigation/utils/mapStyle.dart';
import 'package:dtuNavigation/utils/showSnackbar.dart';

class NavigationScreen extends StatefulWidget {
  static String routeName = '/navigation-screen';
  Marker destination;
  Marker origin;
  Marker? waypoint;
  int currentPointIndex = 0;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<String> instructions = [];

  BitmapDescriptor bitmapDescriptor;
  NavigationScreen(
      {required this.destination,
      required this.origin,
      required this.polylines,
      required this.polylineCoordinates,
      required this.instructions,
      required this.bitmapDescriptor,
      this.waypoint,
      Key? key})
      : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Marker> dtuMarkers = [];
  late Marker origin;
  Polyline newpoly = Polyline(
    polylineId: PolylineId('rasta'),
    width: 3,
    points: [],
  );
  Timer? timer;
  late Marker destination;
  bool once = true;
  late Set<Polyline> polylines;
  Set<Polyline> _polyLines = Set<Polyline>();
  Polyline rasta = Polyline(
    polylineId: PolylineId('rasta'),
    color: Colors.red,
    width: 3,
    points: [],
  );
  int polylineCount = 0;
  late GoogleMapController _controller;
  Position? currentLocation;
  var directions;
  @override
  void initState() {
    origin = widget.origin;
    destination = widget.destination;
    polylines = widget.polylines;
    getCurrentLocation();
    dtuMarkers.add(destination);
    dtuMarkers.add(origin);
    if (widget.waypoint != null) {
      dtuMarkers.add(widget.waypoint!);
    }

    super.initState();
  }

  void tempP() async {
    log("function called");
    int polylineCount = 0;
    Set<Polyline> polylines = {};
    final String polyLineIdVal = 'polyline_id_$polylineCount';
    var directions = await getDirections(origin, destination);
    print("printin directions polyline_decoded");
    print(directions['instruction']);
    polylineCount++;
    List<PointLatLng> points = directions['polyline_decoded'];
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: PolylineId(polyLineIdVal),
        color: Color.fromARGB(255, 0, 207, 131),
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
        width: 3,
      ),
    );
    if (widget.waypoint != null) {
      var directions2 = await getDirections(origin, destination);
      print("printin directions polyline_decoded");
      print(directions2['instruction']);
      polylineCount++;
      List<PointLatLng> points2 = directions2['polyline_decoded'];
      polylines.add(
        Polyline(
          polylineId: PolylineId(polyLineIdVal),
          color: Color.fromARGB(255, 0, 207, 131),
          points: points2.map((e) => LatLng(e.latitude, e.longitude)).toList(),
          width: 3,
        ),
      );
      log("polylinecount incremented");
    }
  }

  void getCurrentLocation() {
    log("get current location function called");
    currentLocation = Position(
      longitude: origin.position.longitude,
      latitude: origin.position.latitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0, altitudeAccuracy: 0,
      headingAccuracy: 0
    );
    log('location object created');
    try {
      Geolocator.getCurrentPosition()
          .then((value) => {
                currentLocation = value,
                log("current location is :" +
                    currentLocation!.latitude.toString() +
                    '   ' +
                    currentLocation!.longitude.toString()),
                updateCameraLocation(
                    LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    destination.position,
                    _controller),
              })
          .catchError((e) {
        log(e.toString());
        return e;
      });
      Geolocator.getPositionStream().listen((event) async {
        currentLocation = event;
        origin = Marker(
          icon: widget.bitmapDescriptor,
          markerId: MarkerId('driver'),
          position: LatLng(event.latitude, event.longitude),
          infoWindow: InfoWindow(
            title: "Delivery Point",
            snippet: "My Position",
          ),
        );
        if (once) {
          once = false;
          updateCameraLocation(
              LatLng(currentLocation!.latitude, currentLocation!.longitude),
              destination.position,
              _controller);
        }
        if (polylineCount <= widget.polylineCoordinates.length - 1) {
          if (Geolocator.distanceBetween(
                  currentLocation!.latitude,
                  currentLocation!.longitude,
                  widget.polylineCoordinates[polylineCount].latitude,
                  widget.polylineCoordinates[polylineCount].longitude) <
              3) {
            log("distance is less than 1.5 meters polylineCount value is :" +
                polylineCount.toString());
            polylineCount++;
            log("polylinecount incremented");
          } else {
            log("distance is greater than 1.5 meters polylineCount value is :" +
                polylineCount.toString());
            if (polylineCount <= widget.polylineCoordinates.length - 1) {
            } else {
              log("polyline count is greater than polyline coordinates length");
            }
          }
        }
        ;
      });
    } on Exception catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> doThis() async {
    print("do this");
    directions = await getDirections(origin, destination);
    print("printin directions polyline_decoded");
    print(directions['polyline_decoded']);
    _setPolylines(directions['polyline_decoded']);
  }

  driverCustomMarker() async {
    log("driver custom marker called");
    final user = context.read<FirebaseAuthMethods>().user;
    var dataBytes;
    var request = await http.get(user.photoURL as Uri);
    var bytes = await request.bodyBytes;
    log('got bytes');

    setState(() {
      dataBytes = bytes;
    });
    if (dataBytes != null) {
      dtuMarkers.add(Marker(
        icon: BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
        markerId: MarkerId('driver'),
        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        infoWindow: InfoWindow(
          title: "You",
        ),
      ));
    }
  }

  Future<Map<String, dynamic>> getDirections(
      Marker origin, Marker destination) async {
    String key = 'AIzaSyCOzoP4mN1S1DuNtDbjOwjRlbSimSSEt10';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.position.latitude},${origin.position.longitude}&destination=${destination.position.latitude},${destination.position.longitude}&key=$key';
    print("making request");
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };
    return results;
  }

  void _setPolylines(List<PointLatLng> points) {
    final String polyLineIdVal = 'polyline_id_$polylineCount';
    polylineCount++;
    _polyLines.add(
      Polyline(
        polylineId: PolylineId(polyLineIdVal),
        color: Color.fromARGB(255, 0, 207, 131),
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
        width: 3,
      ),
    );
    print("added");
  }

  @override
  void dispose() {
    _polyLines.clear();
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home-screen', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return CircleAvatar(
              backgroundColor: Color.fromARGB(255, 0, 255, 162),
              child: IconButton(
                icon: Icon(Icons.menu_rounded),
                color: Colors.black,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            );
          }),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(''),
        ),
        body: Stack(
          children: [
            (applicationBloc.currentLocation == null)
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 255, 162),
                  ))
                : Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GoogleMap(
                      mapToolbarEnabled: true,
                      buildingsEnabled: true,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) async {
                        setState(() {
                          _controller = controller;
                        });
                        controller.setMapStyle(MapStyle.mapStyle);
                        print("map created");
                        updateCameraLocation(
                            origin.position, destination.position, controller);
                      },
                      polylines: polylines,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude,
                            currentLocation!.longitude),
                        zoom: 16,
                        tilt: 80,
                        bearing: 30,
                      ),
                      markers: Set<Marker>.of(dtuMarkers),
                    ),
                  ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(236, 255, 255, 255),
                        const Color.fromARGB(92, 255, 255, 255)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(236, 255, 255, 255),
                        const Color.fromARGB(92, 255, 255, 255)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    parseHtml(widget.instructions[polylineCount]),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 5,
                    maximumSize: const Size(500, 50),
                    minimumSize: const Size(10, 50),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color.fromARGB(255, 0, 255, 162),
                  ),
                  onPressed: () {
                    // CameraUpdate cameraUpdate =
                    //     CameraUpdate.newCameraPosition(CameraPosition(
                    //   target: LatLng(currentLocation!.latitude,
                    //       currentLocation!.longitude),
                    //   zoom: 35,
                    //   tilt: 65,
                    //   bearing: 30,
                    // ));
                    // checkCameraLocation(cameraUpdate, _controller);

                    if (Geolocator.distanceBetween(
                            currentLocation!.latitude,
                            currentLocation!.longitude,
                            destination.position.latitude,
                            destination.position.longitude) >
                        2) {
                      // activate button
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample()),
                      );
                    } else {
                      showSnackBar(context,
                          "Please reach close to the stairs to scan the qr code");
                    }
                  },
                  child: Center(
                    child: Text(
                      "Scan QR Code",
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
            ),
          ],
        ),
      ),
    );
  }

  String parseHtml(String instruction) {
    final Document = parse(instruction);
    final String parsedString =
        parse(Document.body!.text).documentElement!.text;
    return parsedString;
  }
}

Future<void> updateCameraLocation(
  LatLng source,
  LatLng destination,
  GoogleMapController mapController,
) async {
  LatLngBounds bounds;

  if (source.latitude > destination.latitude &&
      source.longitude > destination.longitude) {
    bounds = LatLngBounds(southwest: destination, northeast: source);
  } else if (source.longitude > destination.longitude) {
    bounds = LatLngBounds(
        southwest: LatLng(source.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, source.longitude));
  } else if (source.latitude > destination.latitude) {
    bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, source.longitude),
        northeast: LatLng(source.latitude, destination.longitude));
  } else {
    bounds = LatLngBounds(southwest: source, northeast: destination);
  }

  CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

  return checkCameraLocation(cameraUpdate, mapController);
}

Future<void> checkCameraLocation(
    CameraUpdate cameraUpdate, GoogleMapController mapController) async {
  mapController.animateCamera(cameraUpdate);
  LatLngBounds l1 = await mapController.getVisibleRegion();
  LatLngBounds l2 = await mapController.getVisibleRegion();

  if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
    return checkCameraLocation(cameraUpdate, mapController);
  }
}

void snackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('No response from server!'),
    ),
  );
}
