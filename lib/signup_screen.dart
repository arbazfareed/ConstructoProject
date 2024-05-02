import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signin_screen.dart';
import 'signup_form.dart'; // Import the new file

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _nameEditControl;
  late TextEditingController _emailEditControl;
  late TextEditingController _contactEditControl;
  late TextEditingController _passwordEditControl;
  late TextEditingController _retypePasswordEditControl;

  @override
  void initState() {
    super.initState();
    _nameEditControl = TextEditingController();
    _emailEditControl = TextEditingController();
    _contactEditControl = TextEditingController();
    _passwordEditControl = TextEditingController();
    _retypePasswordEditControl = TextEditingController();
  }

  @override
  void dispose() {
    _nameEditControl.dispose();
    _emailEditControl.dispose();
    _contactEditControl.dispose();
    _passwordEditControl.dispose();
    _retypePasswordEditControl.dispose();
    super.dispose();
  }

  void _signUp() async {
    // Validate form fields
    if (!_validateForm()) {
      return;
    }

    try {
      // Create user with email and password using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailEditControl.text,
        password: _passwordEditControl.text,
      );

      // Add user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameEditControl.text,
        'email': _emailEditControl.text,
        'contactNumber': _contactEditControl.text,
      });

      // Display success message
      _showSnackBar('Sign up successful!', Colors.green);

      // Navigate back to the sign-in screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(userType: '',)),
      );
    } catch (error) {
      // Handle sign-up errors
      _handleSignUpError(error);
    }
  }

  void _handleSignUpError(error) {
    String errorMessage;
    if (error is FirebaseAuthException) {
      // Firebase Authentication error
      errorMessage = 'Sign up failed. Please check your information and try again.';
    } else {
      // Other errors
      errorMessage = 'Sign up failed. Please try again later.';
      // Log specific error on the server-side for debugging purposes
      print('Sign up failed: $error');
    }
    // Display error message
    _showSnackBar(errorMessage, Colors.red);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  bool _validateForm() {
    // Perform client-side validation
    if (_nameEditControl.text.isEmpty ||
        _emailEditControl.text.isEmpty ||
        _contactEditControl.text.isEmpty ||
        _passwordEditControl.text.isEmpty ||
        _retypePasswordEditControl.text.isEmpty) {
      _showSnackBar('Please fill in all fields', Colors.red);
      return false;
    }

    if (_passwordEditControl.text != _retypePasswordEditControl.text) {
      _showSnackBar('Passwords do not match', Colors.red);
      return false;
    }

    // Perform email format validation using regex
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailEditControl.text);
    if (!isEmailValid) {
      _showSnackBar('Invalid email format', Colors.red);
      return false;
    }

    // Add more validation rules as needed

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.person_add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: SignUpForm( // Use the new SignUpForm widget
          nameController: _nameEditControl,
          emailController: _emailEditControl,
          contactController: _contactEditControl,
          passwordController: _passwordEditControl,
          retypePasswordController: _retypePasswordEditControl,
          signUpCallback: _signUp,
        ),
      ),
    );
  }
}
