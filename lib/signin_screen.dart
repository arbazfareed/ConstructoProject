import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin/signup_screen.dart';
import 'package:flutter_signin/home_screen.dart';

class SignInScreen extends StatefulWidget {
  final String userType; // Add userType parameter

  const SignInScreen({Key? key, required this.userType}) : super(key: key); // Update constructor

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailEditControl = TextEditingController();
  TextEditingController _passEditControl = TextEditingController();
  bool _obscurePassword = true; // Define _obscurePassword variable

  Future<void> _signIn() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _emailEditControl.text,
        password: _passEditControl.text,
      );

      // Navigate to home screen if sign-in is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Display error message if sign-in fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: ${_getErrorMessage(e.code)}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Display error message if sign-in fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getErrorMessage(String errorCode) {
    // Map Firebase error codes to user-friendly error messages
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'An error occurred during sign-in. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Colors.white;
    const Color primaryColor = Colors.pink;
    const Color appBarColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Implement navigation or other actions (e.g., forgot password)
            },
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _emailEditControl,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: primaryColor.withOpacity(0.5)),
                  onPressed: () => _emailEditControl.clear(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: primaryColor.withOpacity(0.5)),
                contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              cursorColor: primaryColor,
              cursorWidth: 2.0,
              autocorrect: false,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passEditControl,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: primaryColor),
                suffixIcon: IconButton(
                  icon: _obscurePassword
                      ? Icon(Icons.visibility, color: primaryColor)
                      : Icon(Icons.visibility_off, color: primaryColor),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: primaryColor.withOpacity(0.5)),
                contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (widget.userType != 'Admin') // Show only if user type is not admin
              SizedBox(height: 10),
            if (widget.userType != 'Admin') // Show only if user type is not admin
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  'If Don\'t Sign Up? ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
