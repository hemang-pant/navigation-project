import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
        title: const Text(
          "Notification",
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
                      color: Color.fromARGB(255, 152, 229, 255),
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
                        color: Color.fromARGB(255, 162, 255, 201),
                      ),
                    )),
                from: 500),
            left: -MediaQuery.of(context).size.width * 1,
            top: -MediaQuery.of(context).size.height * 0.2,
          ),
          const Center(child: Text("No Notifications")),
        ],
      ),
    );
  }
}
