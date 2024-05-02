import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'signup_screen.dart';
import 'splash_screen.dart'; // Import the SplashScreen class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  await Firebase.initializeApp(); // Initialize Firebase
  print('Firebase initialization complete.');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constructo App',
      theme: ThemeData(
        // Define your theme data here
      ),
      home: SplashScreen(), // Display splash screen initially
    );
  }
}
