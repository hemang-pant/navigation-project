import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dtuNavigation/models/markers_model.dart';
import 'package:dtuNavigation/utils/station_details_page.dart';

class StationTile extends StatelessWidget {
  AutoGenerate markers;
  List<Marker> dtuMarker;
  Marker start;
  int index;
  StationTile(
      {super.key,
      required this.index,
      required this.markers,
      required this.dtuMarker,
      required this.start});

  @override
  Widget build(BuildContext context) {
    List<String> headings = [
      "TW3GF1",
      "Surveying Lab",
      "Soil Mechanics Lab",
      "Environmental Engineering Lab",
      "DTU Studio",
      "Fluid Mechanics Lab",
      "heading 6",
      "heading 7",
      "heading 8",
      "heading 9",
    ];
    List<String> category = [
      "Civil engineering lecture hall",
      "Survey Engineering",
      "Rock mechanics and strength of materials",
      "Environmental Engineering",
      "Cinematography",
      "Fluid Mechanics",
      "category 6",
      "category 7",
      "category 8",
      "category 9",
    ];
    List<LatLng> positions = [
      LatLng(28.749184741546017, 77.11785411035626),
      LatLng(28.749146906371962, 77.11805976778925),
      LatLng(28.749038131454117, 77.11772936733782),
      LatLng(28.748597034490714, 77.11787439776816),
      LatLng(28.748685219281573, 77.11778990824925),
      LatLng(28.74903501810751, 77.11840346380866),
      LatLng(28.749184741546017, 77.11785411035626),
      LatLng(28.749184741546017, 77.11785411035626),
      LatLng(28.749184741546017, 77.11785411035626),
      LatLng(28.749184741546017, 77.11785411035626),
      LatLng(28.749184741546017, 77.11785411035626),
      LatLng(28.749184741546017, 77.11785411035626),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 0, 0),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StationDetails(
                  origin: start,
                  destination: Marker(
                    markerId: MarkerId(headings[index]),
                    position: positions[index],
                  ),
                  description: category[index],
                ),
              ),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8 - 16,
            height: MediaQuery.of(context).size.height * 0.135,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    headings[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    category[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(148, 0, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                    "${(Geolocator.distanceBetween(start.position.latitude, start.position.longitude, positions[index].latitude, positions[index].longitude) / 1000).toStringAsFixed(2)} KM",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 162, 103),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
