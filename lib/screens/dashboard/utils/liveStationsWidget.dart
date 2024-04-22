import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dtuNavigation/models/markers_model.dart';

import 'stationTile.dart';

class LiveStationsWidget extends StatelessWidget {
  AutoGenerate markers;
  List<Marker> dtuMarker;
  Marker start;
  LiveStationsWidget(
      {super.key,
      required this.markers,
      required this.dtuMarker,
      required this.start});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        StationTile(
            index: 0, markers: markers, dtuMarker: dtuMarker, start: start),
        StationTile(
            index: 1, markers: markers, dtuMarker: dtuMarker, start: start),
        StationTile(
            index: 2, markers: markers, dtuMarker: dtuMarker, start: start),
        StationTile(
            index: 3, markers: markers, dtuMarker: dtuMarker, start: start),
        StationTile(
            index: 4, markers: markers, dtuMarker: dtuMarker, start: start),
        StationTile(
            index: 5, markers: markers, dtuMarker: dtuMarker, start: start),
        StationTile(
            index: 6, markers: markers, dtuMarker: dtuMarker, start: start),
      ],
    ));
  }
}
