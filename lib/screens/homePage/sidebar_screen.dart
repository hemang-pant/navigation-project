import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dtuNavigation/screens/hardwareTest/harwareTestScreen.dart';
import 'package:dtuNavigation/screens/settings/tnc_page.dart';
import 'package:dtuNavigation/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with AutomaticKeepAliveClientMixin {
  late bool userImg = false;

  Uri insta = Uri.parse('https://www.instagram.com/dtuNavigation/');
  Uri website = Uri.parse('https://dtuNavigation.in/');
  Uri twt = Uri.parse('https://twitter.com/go_selectric');
  Uri fb = Uri.parse('https://m.facebook.com/dtuNavigation.official');
  Uri lin = Uri.parse('https://www.linkedin.com/company/dtuNavigation/');
  Uri discord = Uri.parse('https://discord.com/invite/hmGaGdUkcT');
  @override
  void initState() {
    if (context.read<FirebaseAuthMethods>().user.photoURL == null) {
      userImg = false;
    } else {
      userImg = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    super.build(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(238, 255, 255, 255),
                Color.fromARGB(92, 255, 255, 255)
              ],
            ),
          ),
          child: Container(
            color: Colors.transparent,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        child: ClipOval(
                            child: userImg
                                ? Image.network(
                                    user.photoURL ?? '',
                                  )
                                : const Icon(
                                    Icons.person,
                                  )),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        user.displayName ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                if (user.phoneNumber != null ||
                    (!user.emailVerified && user.email != null))
                  (ListTile(
                    title: const Text('Verify Email'),
                    leading: const Icon(Icons.mail),
                    onTap: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .sendEmailVerification(context);
                    },
                  )),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home-screen', (Route<dynamic> route) => false);
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.settings),
                //   title: const Text('Hardware Integration Test'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => HardwareTestScreen()),
                //     );
                //   },
                // ),

                // ListTile(
                //   leading: const Icon(FontAwesomeIcons.readme),
                //   title: const Text('Terms & Conditions'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => TNCScreen(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.contact_support),
                //   title: const Text('About Us'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     showDialog(
                //       context: context,
                //       builder: (context) => BackdropFilter(
                //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                //         child: Center(
                //           child: Container(
                //             width: MediaQuery.of(context).size.width *
                //                 0.91787439613,
                //             height: MediaQuery.of(context).size.height *
                //                 0.69977678571,
                //             decoration: BoxDecoration(
                //               gradient: const LinearGradient(
                //                 begin: Alignment.topCenter,
                //                 end: Alignment.bottomCenter,
                //                 colors: [
                //                   Color.fromARGB(238, 255, 255, 255),
                //                   Color.fromARGB(92, 255, 255, 255)
                //                 ],
                //               ),
                //               borderRadius: BorderRadius.circular(25),
                //             ),
                //             child: Column(
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.all(10.0),
                //                   child: Text(
                //                     "About Us",
                //                     style: GoogleFonts.poppins(
                //                       fontSize: 30,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black,
                //                     ),
                //                   ),
                //                 ),
                //                 Expanded(
                //                   child: ListView(
                //                     scrollDirection: Axis.vertical,
                //                     children: [
                //                       Padding(
                //                         padding: const EdgeInsets.all(10.0),
                //                         child: Text(
                //                           "With the advancement in technology and the automobile industry, Electric Vehicles have an edge over traditional vehicles with a large number of benefits. To EV drivers out there, to solve your further problems regarding EVs, We (dtuNavigation) are here. dtuNavigation is a startup which aims to provide a one-stop solution for EVs. Recently, we won Startup Weekend 2021 by Entrepreneurship Cell of DTU for our startup idea.",
                //                           textAlign: TextAlign.center,
                //                           style: GoogleFonts.poppins(
                //                             fontSize: 15,
                //                             fontWeight: FontWeight.normal,
                //                             color: Colors.black,
                //                           ),
                //                         ),
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.all(10.0),
                //                         child: Text(
                //                           "Join us to be a part of our amazing community #dtuNavigation_Squad Along with knowledge of the EV market, you will get to work with a startup in the future.",
                //                           textAlign: TextAlign.center,
                //                           style: GoogleFonts.poppins(
                //                             fontSize: 15,
                //                             fontWeight: FontWeight.normal,
                //                             color: Colors.black,
                //                           ),
                //                         ),
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceEvenly,
                //                         children: [
                //                           Material(
                //                             color: Colors.transparent,
                //                             child: IconButton(
                //                               onPressed: () => _launchUrl(
                //                                 insta,
                //                               ),
                //                               icon: const Icon(
                //                                   FontAwesomeIcons.instagram),
                //                             ),
                //                           ),
                //                           Material(
                //                             color: Colors.transparent,
                //                             child: IconButton(
                //                               onPressed: () => _launchUrl(fb),
                //                               icon: const Icon(
                //                                   FontAwesomeIcons.facebook),
                //                             ),
                //                           ),
                //                           Material(
                //                             color: Colors.transparent,
                //                             child: IconButton(
                //                               onPressed: () => _launchUrl(twt),
                //                               icon: const Icon(
                //                                   FontAwesomeIcons.twitter),
                //                             ),
                //                           ),
                //                           Material(
                //                             color: Colors.transparent,
                //                             child: IconButton(
                //                               onPressed: () =>
                //                                   _launchUrl(discord),
                //                               icon: const Icon(
                //                                   FontAwesomeIcons.discord),
                //                             ),
                //                           ),
                //                           Material(
                //                             color: Colors.transparent,
                //                             child: IconButton(
                //                               onPressed: () => _launchUrl(lin),
                //                               icon: const Icon(
                //                                   FontAwesomeIcons.linkedin),
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                ListTile(
                  title: const Text('Sign Out'),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
