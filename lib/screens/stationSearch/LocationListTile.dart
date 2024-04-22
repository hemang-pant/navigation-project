import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key, required this.location, required this.press, required this.distance,
  }) : super(key: key);

  final String location;
  final String distance;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          title: Text(location),
          trailing: (distance != '')?Text(
                          "${distance} KM",
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 162, 103),  
                          )):Text(''),
        ),
        Divider(),
      ],
    );
  }
}