import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/blocs/application_bloc.dart';
import 'package:dtuNavigation/models/markers_model.dart';
import 'package:dtuNavigation/screens/homePage/notifications_screen.dart';
import 'dart:async';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';
import 'package:dtuNavigation/utils/station_details_page.dart';
import 'package:dtuNavigation/utils/mapStyle.dart';
import 'package:shimmer/shimmer.dart';

class GoogleMapsPage extends StatefulWidget {
  static var routeName = '/googleMaps';

  GoogleMapsPage({Key? key, void Function(int index)? onAddButtonTapped})
      : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage>
    with AutomaticKeepAliveClientMixin {
  List<Marker> dtuMarkers = [];
  AutoGenerate markers = AutoGenerate(markers: []);
  late Marker closest;
  Uint8List? marketimages;
  List<String> images = ['assets/icons/location.png'];
  bool defined = false;
  bool popupEnlarged = false;
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  LatLng destination = const LatLng(0, 0);
  bool functioncalled = true;
  bool firstTimeCamera = false;
  late Marker currentMarker;
  late Marker destinationMarker;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController mapController;
  bool isloading = true;
  Uint8List markIcons = Uint8List(0);

  @override
  void initState() {
    if (functioncalled) {
      setState(() {
        functioncalled = false;
      });
      customMarker();
      isLoading();
      getMarkerData();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isloading = false;
    });
  }

  onSearch(String search) {
    print("");
  }

  Future<Uint8List> getImages(String path, int width) async {
    log("[marker function called]");
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setPolylines() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyAYCKe8wkUyWtgAhNhBQku9Rn8zsVoAWXg',
        PointLatLng(applicationBloc.currentLocation!.latitude,
            applicationBloc.currentLocation!.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving);
    //api called
    if (result.status == 'OK') {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() => _polylines.add(Polyline(
            polylineId: const PolylineId('poly'),
            color: Colors.red,
            points: polylineCoordinates,
            width: 3,
          )));
    }
  }

  getMarkerData() async {
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
                await customMarker().then((value) => {
                      log("custom marker set"),
                      log("adding markers"),
                      for (int i = 0; i < markers.markers.length; i++)
                        {
                          dtuMarkers.add(manualMarker(
                              LatLng(double.parse(markers.markers[i].latitude),
                                  double.parse(markers.markers[i].longitude)),
                              markers.markers[i].auxaddres.toString(),
                              i.toString()))
                        }
                    });
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
                  log("sorted");
                }

                closest = dtuMarkers[0];
                setState(() {
                  defined = true;
                  log("closest ${closest.position.latitude}, ${closest.position.longitude} distance ${Geolocator.distanceBetween(closest.position.latitude, closest.position.longitude, applicationBloc.currentLocation!.latitude, applicationBloc.currentLocation!.longitude)}");
                });
              }),
            });
  }

  Future<void> customMarker() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/icons/location.png")
        .then((icon) {
      customIcon = icon;
      log("value assigned to customicon ${customIcon}");
    });
  }

  Marker manualMarker(LatLng latLng, String title, String i) {
    return Marker(
      markerId: MarkerId(i),
      position: latLng,
      icon: customIcon,
      onTap: () {
        log("[Selected Marker lat,lng] ${latLng.latitude}, ${latLng.longitude}");
        final applicationBloc =
            Provider.of<ApplicationBloc>(context, listen: false);
        setState(() {
          destinationMarker = Marker(
            markerId: MarkerId(title),
            position: latLng,
            icon: customIcon,
          );
          if (applicationBloc.currentLocation != 0) {
            BitmapDescriptor.fromAssetImage(
                    const ImageConfiguration(
                        devicePixelRatio: 0.1, size: Size(1, 1)),
                    'assets/icons/location.png')
                .then((value) => {
                      setState(() {
                        customIcon = value;
                      })
                    });
            setState(() {
              currentMarker = Marker(
                markerId: const MarkerId("current"),
                position: LatLng(applicationBloc.currentLocation!.latitude,
                    applicationBloc.currentLocation!.longitude),
                infoWindow: const InfoWindow(
                  title: "Current Location",
                  snippet: "Your current location",
                ),
              );
            });
          }
        });
        destination = latLng;
        setPolylines();
        double size = MediaQuery.of(context).size.width * 0.91787439613;
        showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) => Center(
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ui.Color.fromARGB(199, 0, 208, 255),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(title,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Text(
                          "${(Geolocator.distanceBetween(applicationBloc.currentLocation!.latitude, applicationBloc.currentLocation!.longitude, destination.latitude, destination.longitude) / 1000).toStringAsFixed(2)} KM Away from you",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            elevation: 5,
                            minimumSize: const Size(167, 50),
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 255, 162),
                          ),
                          onPressed: () {
                            setState(() {
                              popupEnlarged = true;
                              size = MediaQuery.of(context).size.width *
                                  0.91787439613 *
                                  1.5;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StationDetails(
                                    origin: currentMarker,
                                    destination: destinationMarker),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              "Check Availability",
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      infoWindow: InfoWindow(
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
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
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text('',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        color: ui.Color.fromARGB(171, 188, 255, 255),
        child: Stack(
          children: [
            (isloading != false)
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      trafficEnabled: false,
                      // myLocationEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(MapStyle.mapStyle);
                        setState(() {
                          mapController = controller;
                        });
                        //map crated
                        if (firstTimeCamera) {
                          getMarkerData().then(
                              log("[got markers]"),
                              //got marker data
                              updateCameraLocation(
                                  LatLng(
                                      applicationBloc.currentLocation!.latitude,
                                      applicationBloc
                                          .currentLocation!.longitude),
                                  Set<Marker>.of(dtuMarkers).first.position,
                                  controller));
                          setState(() {
                            firstTimeCamera = false;
                          });
                        }
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            applicationBloc.currentLocation!.latitude,
                            applicationBloc.currentLocation!.longitude),
                        zoom: 16,
                        tilt: 65,
                        bearing: 30,
                      ),
                      markers: Set<Marker>.of([
                        Marker(
                          markerId: MarkerId("TW3GF1"),
                          position: LatLng(28.749184741546017,77.11785411035626 )
                        ),
                        Marker(
                          markerId: MarkerId("Survey Eng. Lab"),
                          position: LatLng(28.749146906371962,77.11805976778925)
                        ),
                        Marker(
                          markerId: MarkerId("Soil Mechanics Lab"),
                          position: LatLng(28.749038131454117, 77.11772936733782)
                        ),
                        Marker(
                          markerId: MarkerId("Environmental Enginerring Lab"),
                          position: LatLng(28.748597034490714 ,77.11787439776816)
                        ),
                        Marker(
                          markerId: MarkerId("DTU Studio"),
                          position: LatLng(28.748685219281573,77.11778990824925)
                        ),
                        Marker(
                          markerId: MarkerId("Fluid Mechanics Labs"),
                          position: LatLng(28.74903501810751,77.11840346380866)
                        ),
                        Marker(
                          markerId: MarkerId("heading 6"),
                          position: LatLng(1, 1)
                        ),

                        Marker(
                          markerId: MarkerId("heading 7"),
                          position: LatLng(1, 1)
                        ),Marker(
                          markerId: MarkerId("heading 8"),
                          position: LatLng(1, 1)
                        ),
                      ]),
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: true,
                      zoomGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomControlsEnabled: false,
                    ),
                  ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
            //     child: Material(
            //       elevation: 5,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.fromLTRB(44, 0, 30, 0),
            //         child: TextField(
            //           style: TextStyle(
            //             decorationColor: Colors.black,
            //             color: Colors.black,
            //           ),
            //           cursorColor: Colors.black,
            //           decoration: InputDecoration(
            //             suffix: Icon(
            //               Icons.search,
            //               color: Colors.black,
            //             ),
            //             fillColor: Colors.white,
            //             border: InputBorder.none,
            //             labelText: "Search",
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(30, 0, 30, 120),
            //     child: (isloading != false)
            //         ? Shimmer.fromColors(
            //             baseColor: Color.fromARGB(255, 183, 255, 229),
            //             enabled: true,
            //             highlightColor: Color.fromARGB(255, 63, 255, 185),
            //             child: TextButton(
            //               style: TextButton.styleFrom(
            //                 foregroundColor: Colors.black,
            //                 elevation: 5,
            //                 minimumSize: const Size(167, 50),
            //                 maximumSize: const Size(167, 50),
            //                 shadowColor: Colors.black,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(30),
            //                 ),
            //                 backgroundColor:
            //                     const Color.fromARGB(255, 0, 255, 162),
            //               ),
            //               onPressed: () {
            //                 setState(() {
            //                   firstTimeCamera = true;
            //                 });

            //                 if (defined) {
            //                   updateCameraLocation(
            //                       LatLng(
            //                           applicationBloc.currentLocation!.latitude,
            //                           applicationBloc
            //                               .currentLocation!.longitude),
            //                       dtuMarkers.first.position,
            //                       mapController);
            //                   log(dtuMarkers.first.markerId.toString());
            //                   dtuMarkers.first.onTap!();
            //                 } else {
            //                   log("not defined");
            //                 }
            //               },
            //               child: Center(
            //                 child: Text(
            //                   "Cqarging Stations Near Me",
            //                   style: GoogleFonts.poppins(
            //                     textStyle: const TextStyle(
            //                         color: Color(0xFF000000),
            //                         fontSize: 15,
            //                         fontWeight: FontWeight.w700),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )
            //         : TextButton(
            //             style: TextButton.styleFrom(
            //               foregroundColor: Colors.black,
            //               elevation: 5,
            //               minimumSize: const Size(240, 50),
            //               maximumSize: const Size(240, 50),
            //               shadowColor: Colors.black,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(30),
            //               ),
            //               backgroundColor:
            //                   const Color.fromARGB(255, 0, 255, 162),
            //             ),
            //             onPressed: () {
            //               setState(() {
            //                 firstTimeCamera = true;
            //               });

            //               if (defined) {
            //                 updateCameraLocation(
            //                     LatLng(
            //                         applicationBloc.currentLocation!.latitude,
            //                         applicationBloc.currentLocation!.longitude),
            //                     dtuMarkers.first.position,
            //                     mapController);
            //                 log(dtuMarkers.first.markerId.toString());
            //                 dtuMarkers.first.onTap!();
            //               } else {
            //                 log("not defined");
            //               }
            //             },
            //             child: Center(
            //               child: Text(
            //                 "Charging Stations Near Me",
            //                 style: GoogleFonts.poppins(
            //                   textStyle: const TextStyle(
            //                       color: Color(0xFF000000),
            //                       fontSize: 15,
            //                       fontWeight: FontWeight.w700),
            //                 ),
            //               ),
            //             ),
            //           ),
            //   ),
            // ),
          ],
        ),
      ),
    );
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
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng((source.latitude + destination.latitude) / 2,
            (source.longitude + destination.longitude) / 2),
        zoom: 16,
        tilt: 65,
        bearing: 30,
      ),
    );

    return checkCameraLocation(cameraUpdate, mapController, bounds);
  }

  Future<void> checkCameraLocation(
    CameraUpdate cameraUpdate,
    GoogleMapController mapController,
    LatLngBounds bounds,
  ) async {
    mapController.animateCamera(cameraUpdate);
    cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
    log('bounds ');
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController, bounds);
    }
  }

  void snackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No response from server!'),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
