import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dtuNavigation/blocs/application_bloc.dart';
import 'package:dtuNavigation/firebase_options.dart';
import 'package:dtuNavigation/models/markers_model.dart';
import 'package:dtuNavigation/screens/firstScreen/first_screen.dart';
import 'package:dtuNavigation/screens/googleMapsScreen/googleMaps_screen.dart';
import 'package:dtuNavigation/screens/homePage/home_screen.dart';
import 'package:dtuNavigation/services/firebase_auth_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notification',
  description: 'Shows notifications for high importance',
  importance: Importance.high,
  showBadge: true,
  enableLights: true,
  enableVibration: true,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: false,
    //systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => ApplicationBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'dtuNavigation',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 0, 255, 162),
            secondary: Color.fromARGB(255, 0, 255, 162),
          ),
          primaryColor: const Color.fromARGB(255, 0, 255, 162),
        ),
        home: AuthWrapper(),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          MyHomePage.routeName: (context) => MyHomePage(
                title: '',
              ),
          GoogleMapsPage.routeName: (context) => GoogleMapsPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  static String routeName = '/auth';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      log("user is not null");
      return const HomeScreen();
    } else {
      return const MyHomePage(title: "");
    }
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/splash.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);

    _playVideo();
  }

  void _playVideo() async {
    // playing video
    _controller.play();

    //add delay till video is complite
    await Future.delayed(const Duration(seconds: 2));
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          Get.to(() => const MyHomePage(title: ''),
              transition: Transition.fadeIn,
              duration: const Duration(seconds: 1));
        } else {
          Get.to(() => const HomeScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(seconds: 1),
              preventDuplicates: true,
              curve: Curves.easeInCubic);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                ),
              )
            : Container(),
      ),
    );
  }
}

class H extends StatefulWidget {
  const H({Key? key}) : super(key: key);

  @override
  _HState createState() => _HState();
}

class _HState extends State<H> {
  int no = 0;
  List<Markers> temp = [];
  List<String> cities = [
    'ahemdabad',
    'banglore',
    'chennai',
    'gurugram',
    'hyderabad',
    'indore',
    'jaipur',
    'noida',
    'pune',
    'mumbai',
  ];
  List _items = [];
  AutoGenerate markers = AutoGenerate(markers: []);
  // Fetch content from the json file
  postDetailsToFirestore() async {
    markers = AutoGenerate(markers: temp);
    log("[markers length]:" + markers.markers.length.toString());
    // calling our firestore
    // calling our user model
    // sending these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("markers").add(markers.toJson()).then(
        (value) =>
            Fluttertoast.showToast(msg: "Account created successfully :) "));
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/new-marker.json');
    final data = await json.decode(response);
    log(no.toString());
    for (int i = 0; i < data.length; i++) {
      if (data[i]['latitude'] != null &&
          data[i]['longitude'] != null &&
          data[i]['address'] != null &&
          data[i]['city'] != null) {
        temp.add(Markers(
          address: data[i]['address'],
          auxaddres: data[i]['name'],
          no: no,
          region: data[i]['zone'].toString(),
          latitude: double.parse(data[i]['latitude'].toString()).toString(),
          longitude: double.parse(data[i]['longitude'].toString()).toString(),
          power: data[i]['power'].toString(),
          service: data[i]['service'].toString(),
          type: data[i]['type'].toString(),
        ));
        no++;
      } else {
        log("null at $no");
        log(data[i].toString());
      }
    }

    for (int i = 0; i < cities.length; i++) {
      await cityJson(cities[i]);
    }
    markers = AutoGenerate(markers: temp);
    log("[markers length]:" + markers.markers.length.toString());
  }

  Future<void> cityJson(String city) async {
    log(city);
    final String response =
        await rootBundle.loadString('assets/data/' + city + '.json');
    final data = await json.decode(response);
    log(no.toString());
    for (int i = 0; i < data.length; i++) {
      if (data[i]['latitude'] != null &&
          data[i]['longitude'] != null &&
          data[i]['address'] != null) {
        log(city);
        temp.add(Markers(
          address: data[i]['address'],
          auxaddres: data[i]['name'],
          no: no,
          region: city,
          latitude: double.parse(data[i]['latitude'].toString()).toString(),
          longitude: double.parse(data[i]['longitude'].toString()).toString(),
          power: city,
          service: city,
          type: city,
        ));
        no++;
      } else {
        log("null at $no");
        log(data[i].toString());
      }
    }
    markers = AutoGenerate(markers: temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Kindacode.com',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Load Data'),
              onPressed: readJson,
            ),
            ElevatedButton(
              child: const Text('Send Data'),
              onPressed: postDetailsToFirestore,
            ),
            // Display the data loaded from sample.json
            markers.markers.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Text(markers.markers[index].no.toString()),
                            title: Text(_items[index]["region"]),
                            subtitle: Text(_items[index]["address"]),
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
