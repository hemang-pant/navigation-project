import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dtuNavigation/screens/login/login.dart';
import 'package:dtuNavigation/screens/login/signup_page.dart';
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatefulWidget {
  static const String routeName = '/first_screen';

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  @override
  void initState() {
    loading();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void loading() async {
    log("abcdefg");
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                ),
              ),
              from: 500,
              delay: Duration(milliseconds: 500),
            ),
            right: -MediaQuery.of(context).size.width * 0.5,
            bottom: -MediaQuery.of(context).size.height * 0.1,
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
                ),
              ),
              from: 500,
              delay: Duration(milliseconds: 500),
            ),
            left: -MediaQuery.of(context).size.width * 0.5,
            top: -MediaQuery.of(context).size.height * 0.2,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                Spacer(),
                Image.asset('assets/dtu-logo.png',
                    height: 180, width: 180, fit: BoxFit.contain),
                Row(
                  children: [
                    Spacer(),
                    DefaultTextStyle(
                      style: GoogleFonts.ptSans(
                        textStyle: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 45,
                            fontWeight: FontWeight.w700),
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        displayFullTextOnTap: true,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            'DTU',
                            speed: Duration(milliseconds: 100),
                          ),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                    Text(
                      'Navigation',
                      style: GoogleFonts.ptSans(
                        textStyle: const TextStyle(
                            color: Color.fromARGB(225, 22, 217, 147),
                            fontSize: 45,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Spacer()
                  ],
                ),
                Text(
                  'One Stop solution for DTU navigation.',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: (isLoading)
                      ? Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 183, 255, 229),
                          enabled: true,
                          highlightColor: Color.fromARGB(255, 63, 255, 185),
                          child: MaterialButton(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 50,
                            minWidth: const Size.fromHeight(50).width,
                            color: const Color.fromARGB(255, 0, 255, 162),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginaScreen(title: ''),
                                ),
                              );
                            },
                            child: Text(
                              "Log in",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        )
                      : MaterialButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 50,
                          minWidth: const Size.fromHeight(50).width,
                          color: const Color.fromARGB(255, 0, 255, 162),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginaScreen(title: ''),
                              ),
                            );
                          },
                          child: Text(
                            "Log in",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: (isLoading)
                      ? Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 221, 255, 242),
                          enabled: true,
                          highlightColor: Color.fromARGB(255, 82, 255, 192),
                          child: MaterialButton(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 50,
                            minWidth: const Size.fromHeight(50).width,
                            color: const Color.fromARGB(255, 0, 255, 162),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginaScreen(title: ''),
                                ),
                              );
                            },
                            child: Text(
                              "Log in",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        )
                      : MaterialButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 50,
                          minWidth: const Size.fromHeight(50).width,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignUpPage(title: 'a'),
                              ),
                            );
                          },
                          child: Text(
                            "Create account",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                ),
                const Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
