import 'package:flutter/material.dart';
import 'package:flutter_signin/signup_buttons.dart';
import 'signin_screen.dart'; // Import the sign-in screen

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  final TextEditingController passwordController;
  final TextEditingController retypePasswordController;
  final VoidCallback signUpCallback;

  const SignUpForm({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.contactController,
    required this.passwordController,
    required this.retypePasswordController,
    required this.signUpCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20),
        TextField(
          controller: contactController,
          decoration: InputDecoration(
            labelText: 'Contact No.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        TextField(
          controller: retypePasswordController,
          decoration: InputDecoration(
            labelText: 'Retype Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        SignUpButton(
          onPressed: signUpCallback,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen(userType: '',)),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadowColor: Colors.grey.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
