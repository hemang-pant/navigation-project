import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dtuNavigation/screens/homePage/sidebar_screen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:dtuNavigation/screens/settings/tnc_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import '../../services/firebase_auth_methods.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, void Function(int index)? onAddButtonTapped})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hasBiometricsEnabled = false;

  Uri website = Uri.parse('https://dtuNavigation.com/');

  Uri playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.dtuNavigation.dtuNavigationapp&hl=en&pli=1');

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      drawer: const NavBar(),
    );
  }

  Widget get body {
    return Container(
      color: ui.Color.fromARGB(171, 188, 255, 255),
      child: SettingsList(
        lightTheme:
            const SettingsThemeData(settingsListBackground: Colors.transparent),
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                trailing: const Icon(Icons.notifications_active_rounded),
                title: Text(
                  'Notification',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // SettingsTile.navigation(
              //   onPressed: (context) {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => TNCScreen(),
              //       ),
              //     );
              //   },
              //   trailing: const Icon(Icons.chevron_right),
              //   title: Text(
              //     'Terms of Service',
              //     style: GoogleFonts.montserrat(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              SettingsTile.navigation(
                onPressed: (context) {
                  _launchUrl(website);
                },
                trailing: const Icon(Icons.chevron_right),
                title: Text(
                  'Help Center',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsTile.navigation(
                onPressed: (context) {
                  _launchUrl(playStoreUrl);
                },
                trailing: const Icon(Icons.chevron_right),
                title: Text(
                  'Give Feedback',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SettingsTile.navigation(
                onPressed: (context) =>
                    {context.read<FirebaseAuthMethods>().signOut(context)},
                trailing: const Icon(Icons.chevron_right),
                title: Text(
                  'Log out',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      backgroundColor: ui.Color.fromARGB(171, 188, 255, 255),
      elevation: 0,
      title: const Text(
        "Settings",
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  void toggleBiometricsLogin(val) async {
    setState(() {});
  }
}
