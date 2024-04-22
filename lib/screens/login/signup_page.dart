import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/screens/login/login.dart';
import 'package:dtuNavigation/screens/login/otp_page.dart';
import 'package:dtuNavigation/services/firebase_auth_methods.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late bool isPasswordVisible = true;
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  bool isCredCorrect = true;
  void signUpWithEmail() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          firstName: nameEditingController.text,
          email: emailEditingController.text,
          password: passwordEditingController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: SlideInRight(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 2.18,
                  height: MediaQuery.of(context).size.height * 2.18,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 162, 255, 201),
                    ),
                  )),
              from: 500,
            ),
            left: -MediaQuery.of(context).size.width * 0,
            bottom: -MediaQuery.of(context).size.height * .595,
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Spacer(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(21, 30, 0, 10),
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          elevation: 5,
                          maximumSize: const Size(167, 50),
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          context
                              .read<FirebaseAuthMethods>()
                              .signInWithGoogle(context);
                        },
                        child: Row(
                          children: [
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/512/2991/2991148.png",
                              height: 33,
                            ),
                            const SizedBox(
                              width: 23,
                            ),
                            Text(
                              "Google",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        elevation: 5,
                        minimumSize: const Size(167, 50),
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 255, 162),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreenScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "Phone Number",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(37.0),
                child: Center(child: Text("or Sign up using")),
              ),
              if (!isCredCorrect)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: (Text("The mail or password you entered is wrong",
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ))),
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
                      autofillHints: const [
                        AutofillHints.name,
                      ],
                      controller: nameEditingController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Name",
                      ),
                    ),
                  ),
                ),
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
                      autofillHints: const [
                        AutofillHints.email,
                      ],
                      controller: emailEditingController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Mail",
                      ),
                    ),
                  ),
                ),
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
                      controller: passwordEditingController,
                      cursorColor: Colors.black,
                      autofillHints: const [
                        AutofillHints.password,
                      ],
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.remove_red_eye_rounded,
                              color: Color.fromARGB(250, 0, 206, 201)),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Forgot your password?",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 5,
                    minimumSize: const Size(167, 50),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color.fromARGB(255, 0, 255, 162),
                  ),
                  onPressed: () {
                    if (emailEditingController.text.isNotEmpty &&
                        passwordEditingController.text.isNotEmpty &&
                        nameEditingController.text.isNotEmpty) {
                      signUpWithEmail();
                    } else {
                      setState(() {
                        isCredCorrect = false;
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      "Log in",
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 74),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.ptSans(
                        textStyle: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle()),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginaScreen(title: 'a'),
                                  ),
                                );
                              },
                            text: 'Sign In',
                            style: const TextStyle(
                                color:
                                    const Color.fromARGB(225, 22, 217, 147))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
