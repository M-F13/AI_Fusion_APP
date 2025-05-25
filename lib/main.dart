//
// import 'package:fyp/screen/home_screen.dart';
// import 'package:fyp/screen/login_page.dart';
// import 'package:fyp/screen/onboarding_screen.dart';
// import 'package:fyp/screen/signup_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'apis/apis.dart';
// import 'apis/app_write.dart';
// import 'helper/global.dart';
// import 'helper/pref.dart';
// import 'screen/splash_screen.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // 2. Initialize environment variables FIRST
//   await dotenv.load(fileName: ".env");
//
//   // 3. Initialize APIs (loads the env vars)
//   await APIs.initialize();
//
//   // 4. Firebase initialization (web vs mobile)
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: "AIzaSyDe7CYuF5aW7BFqdUZl3BLSV9FLYTFZelA",
//         appId: "1:318109838368:web:ce795698c6a4fdf5eb2045",
//         // messagingSenderId: "Regards MF",
//         messagingSenderId: "318109838368",
//         projectId: "ai-fusion-fyp",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//
//   // 5. Other initializations
//   await Pref.initialize();
//   await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   // 📸 Request permissions (camera, gallery)
//   await _requestInitialPermissions();
//
//
//   // 6. Run the app
//   runApp(const MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: appName,
//       debugShowCheckedModeBanner: false,
//       routes: {
//         '/': (context) => SplashScreen(
//           child: OnboardingScreen(),
//         ),
//         '/login': (context) => LoginPage(),
//         '/signUp': (context) => SignupPage(),
//         '/home': (context) => HomeScreen(),
//       },
//       themeMode: Pref.defaultTheme,
//
//       // Dark Theme
//       darkTheme: ThemeData(
//         useMaterial3: false,
//         brightness: Brightness.dark,
//         primaryColor: Colors.blue.shade800,
//         primaryColorDark: Colors.blue.shade900,
//         appBarTheme: _buildAppBarTheme(),
//         cardTheme: CardTheme(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
//
//       // Light Theme
//       theme: ThemeData(
//         useMaterial3: false,
//         primaryColor: Colors.blue,
//         primaryColorDark: Colors.blue.shade700,
//         appBarTheme: _buildAppBarTheme(),
//         cardTheme: CardTheme(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Common AppBar theme builder
//   static AppBarTheme _buildAppBarTheme() {
//     return AppBarTheme(
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: const TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//       iconTheme: const IconThemeData(color: Colors.white),
//     );
//   }
// }
//
// extension AppTheme on ThemeData {
//   Color get lightTextColor =>
//       brightness == Brightness.dark ? Colors.white70 : Colors.black54;
//
//   Color get buttonColor => brightness == Brightness.dark
//       ? Colors.blue.withOpacity(.5)
//       : Colors.blue;
// }
//
// Future<void> _requestInitialPermissions() async {
//   await [Permission.camera, Permission.storage].request();
// }










import 'dart:developer';

import 'package:fyp/screen/feature/image_feature.dart';
import 'package:fyp/screen/home_screen.dart';
import 'package:fyp/screen/login_page.dart';
import 'package:fyp/screen/onboarding_screen.dart';
import 'package:fyp/screen/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'apis/apis.dart';
import 'controller/ocr_services.dart';
import 'helper/global.dart';
import 'helper/pref.dart';
import 'screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String config = await rootBundle.loadString('assets/tessdata_config.json');
  print(config);
  // 2. Initialize environment variables FIRST
  await dotenv.load(fileName: ".env");

  // 3. Initialize APIs (loads the env vars)
  await APIs.initialize();

  // 4. Firebase initialization (web vs mobile)
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDe7CYuF5aW7BFqdUZl3BLSV9FLYTFZelA",
        // for web
        // appId: "1:318109838368:web:ce795698c6a4fdf5eb2045",
        // for android
        appId: "1:318109838368:android:fa3c509ec3d20855eb2045",
        // for IOS
        // appId: "1:318109838368:web:ce795698c6a4fdf5eb2045",
        // messagingSenderId: "Regards MF",
        messagingSenderId: "318109838368",
        projectId: "ai-fusion-fyp",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // 5. Other initializations
  await Pref.initialize();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  // Add this before runApp()
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('Impeller') ||
        details.exception.toString().contains('OpenGL')) {
      log('Graphics error suppressed: ${details.exception}');
      return;
    }
    FlutterError.presentError(details);
  };

  Get.put(OcrController()); // Register the controller

  // 6. Run the app
  runApp(FutureBuilder(future: Future.delayed(Duration(seconds: 1)),
      builder: (context, snapshot){
    return MyApp();
      }));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(
          // child: OnboardingScreen(),
        ),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignupPage(),
        '/home': (context) => HomeScreen(),
        // '/Widget': (context) => (),        // Replace with your actual widget screen
        '/ImageFeature': (context) => ImageFeature(),
      },
      themeMode: Pref.defaultTheme,

// Dark Theme - Professional & Soothing Version
      darkTheme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,

        // ========== 1. COLOR SCHEME ========== //
        primaryColor: Colors.blueGrey.shade300,  // Muted blue-grey (softer than pure blue)
        primaryColorDark: Colors.blueGrey.shade400,
        scaffoldBackgroundColor: const Color(0xFF191A1C),  // Warm dark gray (not pure black)
        cardColor: const Color(0xFF242424),  // Slightly lighter than scaffold
        dialogBackgroundColor: const Color(0xFF242424),
        dividerColor: Colors.blueGrey.shade700.withOpacity(0.4),  // Subtle dividers

        // ========== 2. TEXT & TYPOGRAPHY ========== //
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),  // Soft white
          bodyMedium: TextStyle(color: Colors.white70),
          titleMedium: TextStyle(color: Colors.white),
        ),

        // ========== 3. COMPONENT STYLING ========== //
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFF242424),  // Matches cards
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white70,  // Not pure white
          ),
          iconTheme: const IconThemeData(color: Colors.white70),
        ),

        cardTheme: CardTheme(
          elevation: 1,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFF242424),  // Warm gray
        ),

        // ========== 4. INPUT FIELDS ========== //
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2D2D2D),  // Darker than cards
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,  // No harsh borders
          ),
          hintStyle: TextStyle(color: Colors.blueGrey.shade400),
        ),

        // ========== 5. BUTTONS ========== //
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade500,  // Muted button color
            foregroundColor: Colors.white70,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

// Light Theme (kept your existing version)
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue.shade700,
        appBarTheme: _buildAppBarTheme(),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // Common AppBar theme builder
  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightTextColor =>
      brightness == Brightness.dark ? Colors.white70 : Colors.black54;

  Color get buttonColor => brightness == Brightness.dark
      ? Colors.blue.withOpacity(.5)
      : Colors.blue;
}




