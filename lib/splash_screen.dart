// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_signin/signin_screen.dart';
import 'dart:async';

import 'package:flutter_signin/user_type_dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _animatedText = ''; // Text to be animated
  int _currentIndex = 0; // Index of the current letter
  final List<String> _textLetters = ['C', 'o', 'n', 's', 't', 'r', 'u', 'c', 't', 'o']; // List of letters in "Constructo"

  @override
  void initState() {
    super.initState();
    // Start the animation when the screen loads
    _startAnimation();
  }

  // Function to start the animation
  void _startAnimation() {
    // Timer to animate each letter one by one with color shift
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_currentIndex < _textLetters.length) {
        // Add the next letter to the animated text with color shift
        setState(() {
          _animatedText += _textLetters[_currentIndex];
          _currentIndex++;
        });
      } else {
        // Stop the timer when all letters are animated
        timer.cancel();
        // Add a brief delay before showing the user type dialog
        Future.delayed(Duration(seconds: 2), () {
          // Show the user type dialog
          _showUserTypeDialog();
        });
      }
    });
  }

  // Function to show the user type dialog
  void _showUserTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserTypeDialog(); // Using UserTypeDialog widget from separate file
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Icon related to construction
            Icon(
              Icons.construction,
              size: 100, // Adjust size as needed
              color: Colors.white, // Set icon color
            ),
            SizedBox(height: 20),
            // Animated text "Constructo" with color shift and emphasis on 'o'
            Text(
              _animatedText,
              style: TextStyle(
                fontSize: 36, // Adjust font size as needed
                fontWeight: FontWeight.bold, // Set font weight
                // Apply color shift animation
                color: _currentIndex % 2 == 0 ? Colors.white : Colors.blue,
                // Emphasize 'o' by making it larger and using a different color
                shadows: _currentIndex == 5
                    ? [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ]
                    : null,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set progress indicator color
            ), // Display a loading indicator
          ],
        ),
      ),
    );
  }
}
