import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/services/firebase_auth_methods.dart';

enum Location { gate, canteen, micmac, mechc, oat, audi, acaddept }

class OTPScreenScreen extends StatefulWidget {
  static String routeName = '/OTPScreen-screen';
  OTPScreenScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenScreenState createState() => _OTPScreenScreenState();
}

class _OTPScreenScreenState extends State<OTPScreenScreen> {
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Positioned(
                child: SlideInLeft(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 2.18,
                        height: MediaQuery.of(context).size.height * 2.18,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 152, 229, 255),
                          ),
                        )),
                    from: 500),
                right: -MediaQuery.of(context).size.width * 0,
                bottom: -MediaQuery.of(context).size.height * .595,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "OTP Verification",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Verification code will be sent to your mobile number",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: Material(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(44, 0, 30, 0),
                        child: TextField(
                          style: const TextStyle(
                            decorationColor: Colors.black,
                            color: Colors.black,
                          ),
                          cursorColor: Colors.black,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autofillHints: [
                            AutofillHints.telephoneNumber,
                          ],
                          controller: phoneController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            prefixText: "+91 ",
                            labelText: "Phone Number",
                            hintText: "",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 50,
                      elevation: 5,
                      minWidth: const Size.fromHeight(50).width,
                      color: const Color.fromARGB(255, 0, 255, 162),
                      onPressed: () {
                        context
                            .read<FirebaseAuthMethods>()
                            .phoneSignIn(context, phoneController.text);
                      },
                      child: Text(
                        "Submit",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
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
  }
}
