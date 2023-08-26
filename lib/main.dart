import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_shield_alpha/animation/onboarding_screen.dart';
import 'package:snap_shield_alpha/providers/user_provider.dart';
import 'package:snap_shield_alpha/responsive/mobile_screen_layout.dart';
import 'package:snap_shield_alpha/responsive/responsive_layout.dart';
import 'package:snap_shield_alpha/responsive/web_screen_layout.dart';
import 'package:snap_shield_alpha/screens/login_screen.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDbIak3XvK2icemBNU3YJ_fZOZkCND3DiU",
        projectId: "snap-shield-aplha",
        storageBucket: "snap-shield-aplha.appspot.com",
        messagingSenderId: "606658084614",
        appId: "1:606658084614:web:f064073dc546516e2d6887",
      ),
    );
  } else {
    await Firebase.initializeApp();
    // await FirebaseCustomMl.instance.setup();
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Snap Shield',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const OnboardingScreen();
            // return const LoginScreen();
          },
        ),
      ),
    );
  }
}
