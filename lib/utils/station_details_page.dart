import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/utils/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../services/firebase_auth_methods.dart';

enum Location { gate, canteen, micmac, mechc, oat, audi, acaddept }

class StationDetails extends StatefulWidget {
  static String routeName = '/home-screen';
  Marker destination;
  Marker origin;
  String description;
  StationDetails(
      {required this.destination,
      required this.origin,
      this.description = "",
      Key? key})
      : super(key: key);

  @override
  _StationDetailsState createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {
  late Marker destination;
  late Marker origin;
  late List<String> instructionText = [''];
  late List<LatLng> instructionsPoint = [origin.position];
  late String placeType = 'restaurant';
  List<Marker> dtuMarkers = [];
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    destination = widget.destination;
    origin = widget.origin;
    customMarker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> getDirections(
      Marker origin, Marker destination) async {
    instructionText.remove('');
    String key = 'AIzaSyCOzoP4mN1S1DuNtDbjOwjRlbSimSSEt10';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.position.latitude},${origin.position.longitude}&destination=${destination.position.latitude},${destination.position.longitude}&key=$key';
    log("making request");
    log("url: $url");
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    log("[json data]: ${json['routes'][0]['legs'][0]['steps'][0]['html_instructions']}");
    log("json made");

    for (int i = 0; i < json['routes'][0]['legs'][0]['steps'].length; i++) {
      instructionText
          .add(json['routes'][0]['legs'][0]['steps'][i]['html_instructions']);
      instructionsPoint.add(LatLng(
          json['routes'][0]['legs'][0]['steps'][i]['end_location']['lat'],
          json['routes'][0]['legs'][0]['steps'][i]['end_location']['lng']));
      json['routes'][0]['legs'][0]['steps'][i]['start_location'];
      log("instructionText: ${instructionText[i]}");
      log("instructionsPoint: ${instructionsPoint[i]}");
    }

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'instruction': json['routes'][0]['legs'][0]['steps'][0]
          ['html_instructions'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    return results;
  }

  customMarker() async {
    log("driver custom marker called");
    final user = context.read<FirebaseAuthMethods>().user;
    if (user.photoURL != null) {
      var dataBytes;
      log("user.photoURL: ${user.photoURL}");
      await http.get(Uri.parse(user.photoURL!)).then((value) {
        setState(() {
          dataBytes = value.bodyBytes;
        });
      });
      dtuMarkers.add(Marker(
        icon: BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
        markerId: MarkerId('driver'),
        position: origin.position,
        infoWindow: InfoWindow(
          title: "Delivery Point",
          snippet: "My Position",
        ),
      ));
      customIcon = BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List());
      log(dtuMarkers[0].icon.toString());
    } else {
      log("user.photoURL: ${user.photoURL}");
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration.empty, "assets/icons/driver-icon.png")
          .then((icon) {
        setState(() {
          customIcon = icon;
          log("customIcon: $customIcon");
        });
        log("value assigned to customicon ${customIcon}");
        dtuMarkers.add(Marker(
          icon: icon,
          markerId: MarkerId('driver'),
          position: origin.position,
          infoWindow: InfoWindow(
            title: "Delivery Point",
            snippet: "My Position",
          ),
        ));
      });
    }
  }

  Marker manualMarker(LatLng latLng, String title) {
    return Marker(
      markerId: MarkerId(title),
      position: latLng,
      onTap: () {},
      infoWindow: InfoWindow(
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 0, 255, 162),
          child: IconButton(
            icon: Icon(Icons.menu_rounded),
            color: Colors.black,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.heart,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        title: const Text(
          "Navigation",
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: SlideInDown(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 3,
                  height: MediaQuery.of(context).size.height * 3,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 162, 255, 201),
                    ),
                  )),
              from: 500,
            ),
            left: -MediaQuery.of(context).size.width * 1,
            bottom: -MediaQuery.of(context).size.height * 0.8,
          ),
          Positioned(
            child: SlideInUp(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 3,
                    height: MediaQuery.of(context).size.height * 3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 152, 229, 255),
                      ),
                    )),
                from: 500),
            left: -MediaQuery.of(context).size.width * 1,
            top: -MediaQuery.of(context).size.height * 0.2,
          ),
          Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/jagah.png'),
                  radius: MediaQuery.of(context).size.width * 0.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(destination.markerId.value,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Text(
                  '${(Geolocator.distanceBetween(origin.position.latitude, origin.position.longitude, destination.position.latitude, destination.position.longitude) / 1000).toStringAsFixed(2)}KM Away from you',
                  style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text(widget.description,
                  style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(58, 0, 64, 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("2 Wheelers, 3 Wheeler and 4 wheelers",
                      style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 5,
                    minimumSize: const Size(167, 50),
                    maximumSize: Size(180, 50),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: ui.Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () async {
                    log("function called");
                    Uri googleUrl = Uri.parse(
                        'https://www.google.com/maps/dir/?api=1&origin=' +
                            widget.origin.position.latitude.toString() +
                            ',' +
                            widget.origin.position.longitude.toString() +
                            '&destination=' +
                            widget.destination.position.latitude.toString() +
                            ',' +
                            widget.destination.position.longitude.toString() +
                            '&travelmode=driving');

                    _launchUrl(googleUrl);
                  },
                  child: Center(
                    child: Text(
                      "Google Maps",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 5,
                    minimumSize: const Size(167, 50),
                    maximumSize: Size(180, 50),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color.fromARGB(255, 0, 255, 162),
                  ),
                  onPressed: () async {
                    log("function called");
                    int polylineCount = 0;
                    Set<Polyline> polylines = {};
                    final String polyLineIdVal = 'polyline_id_$polylineCount';
                    instructionText.remove('');
                    var directions = await getDirections(origin, destination);
                    print("printin directions polyline_decoded");
                    print(directions['instruction']);
                    polylineCount++;
                    List<PointLatLng> points = directions['polyline_decoded'];
                    polylines.add(
                      Polyline(
                        polylineId: PolylineId(polyLineIdVal),
                        color: Color.fromARGB(255, 0, 207, 131),
                        points: points
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                        width: 3,
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationScreen(
                          origin: dtuMarkers[0],
                          destination: destination,
                          polylines: polylines,
                          instructions: instructionText,
                          polylineCoordinates: instructionsPoint,
                          bitmapDescriptor: customIcon,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Take Me there!",
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
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $_url';
  }
}

void snackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('No response from server!'),
    ),
  );
}
