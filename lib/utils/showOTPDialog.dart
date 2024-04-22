import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  showDialog(
                    context: context,
                    builder: (context) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Center(
                        child: Container(
                          width:
                              MediaQuery.of(context).size.width * 0.91787439613,
                          height: MediaQuery.of(context).size.height *
                              0.3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(238, 255, 255, 255),
                                Color.fromARGB(92, 255, 255, 255)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Material(
                                  color: Colors.transparent,
                                  textStyle:GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  child: const Text(
                                    "Enter OTP",
                                  ),
                                ),
                              ),
                              Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(44, 0, 30, 0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    decorationColor: Colors.black,
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  enableSuggestions: true,
                  controller: codeController,
                  autofillHints: const [
                    AutofillHints.oneTimeCode,
                  ],
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    labelText: "OTP",
                    hintText: "XXXXXX",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, elevation: 5,
                minimumSize: const Size(167, 50),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(255, 0, 255, 162),
              ),
              onPressed: onPressed,
              child: Center(
                child: Text(
                  "Verify OTP", 
                  style: GoogleFonts.montserrat(
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
                        ),
                      ),
                    ),
                  );
                }