import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/screens/login/otp_page.dart';
import 'package:dtuNavigation/screens/login/signup_page.dart';
import 'package:dtuNavigation/services/firebase_auth_methods.dart';
import 'package:shimmer/shimmer.dart';

class LoginaScreen extends StatefulWidget {
  const LoginaScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LoginaScreen> createState() => _LoginaScreenState();
}

class _LoginaScreenState extends State<LoginaScreen> {
  bool isloading = true;
  late bool isPasswordVisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isCredCorrect = true;
  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
  }

  @override
  void initState() {
    isLoading();
    super.initState();
  }

  void isLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              from: 500,
            ),
            right: -MediaQuery.of(context).size.width * 0,
            bottom: -MediaQuery.of(context).size.height * .595,
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Spacer(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "Log in",
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
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: (isloading)
                    ? Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 183, 255, 229),
                        enabled: true,
                        highlightColor: Color.fromARGB(255, 63, 255, 185),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            elevation: 5,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/2991/2991148.png",
                                height: 33,
                              ),
                              const Spacer(),
                              Text(
                                "Google",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          elevation: 5,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/512/2991/2991148.png",
                              height: 33,
                            ),
                            const Spacer(),
                            Text(
                              "Google",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: (isloading)
                    ? Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 183, 255, 229),
                        enabled: true,
                        highlightColor: Color.fromARGB(255, 63, 255, 185),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreenScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    : TextButton(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPScreenScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
              ),
              const SizedBox(
                height: 37,
              ),
              const Center(child: Text("or log in using")),
              const SizedBox(
                height: 37,
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
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: (isloading)
                    ? Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 183, 255, 229),
                        enabled: true,
                        highlightColor: Color.fromARGB(255, 255, 255, 255),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreenScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    : Material(
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
                            controller: _emailController,
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              labelText: "Email",
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 37,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: (isloading)
                    ? Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 183, 255, 229),
                        enabled: true,
                        highlightColor: Color.fromARGB(255, 255, 255, 255),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreenScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    : Material(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(44, 0, 30, 0),
                          child: TextField(
                            obscureText: isPasswordVisible,
                            autofillHints: const [
                              AutofillHints.password,
                            ],
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              decorationColor: Colors.black,
                              color: Colors.black,
                            ),
                            controller: _passwordController,
                            cursorColor: Colors.black,
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
                child: (isloading)
                    ? Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 183, 255, 229),
                        enabled: true,
                        highlightColor: Color.fromARGB(255, 63, 255, 185),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreenScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    : TextButton(
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
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            context.read<FirebaseAuthMethods>().loginWithEmail(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context,
                                );
                          }
                          setState(() {
                            isCredCorrect = false;
                          });
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
                            text: 'Don’t have an account yet? ',
                            style: TextStyle()),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(
                                      title: "a",
                                    ),
                                  ),
                                );
                              },
                            text: 'Sign up',
                            style: const TextStyle(
                                color: Color.fromARGB(225, 22, 217, 147))),
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
