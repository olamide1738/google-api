import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:users/screens/login_screen.dart';
import 'package:users/screens/main_screen.dart';
import 'package:users/screens/register_screen.dart';
import 'package:users/splashScreen/splash_screen.dart';
import 'package:users/themeProvider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
