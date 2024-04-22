import 'dart:async';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/blocs/application_bloc.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';

class HardwareTestScreen extends StatefulWidget {
  HardwareTestScreen({Key? key}) : super(key: key);

  @override
  State<HardwareTestScreen> createState() => _HardwareTestScreenState();
}

class _HardwareTestScreenState extends State<HardwareTestScreen> {
  var numCars = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    log('initState running');
    //getMarkerData();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getMarkerData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Dashboard',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
      ),
      body: Stack(
        children: [
          Center(
              child: Text("No. Of Cars Detected: ${numCars}",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ))),
        ],
      ),
    );
  }

  getMarkerData() async {
    log('function called');
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    var collection = FirebaseFirestore.instance.collection('hardware_data');
    // userUid is the current authenticated user
    var docSnapshot =
        await collection.doc('station_name').get().then((docSnapshot) {
      Map<String, dynamic> data = docSnapshot.data()!;
      log('numCars: ${numCars}');
      setState(() {
        numCars = data['vehicle_count'];
      });
    });
  }
}
