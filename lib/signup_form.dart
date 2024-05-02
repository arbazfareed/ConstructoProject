import 'package:flutter/material.dart';
import 'package:flutter_signin/signup_buttons.dart';
import 'signin_screen.dart'; // Import the sign-in screen

class SignUpForm extends StatefulWidget {
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
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _passwordVisible = false;
  String _passwordStrength = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('Name', widget.nameController, TextInputType.text),
        SizedBox(height: 20),
        _buildTextField('Email', widget.emailController, TextInputType.emailAddress),
        SizedBox(height: 20),
        _buildTextField('Contact No.', widget.contactController, TextInputType.phone),
        SizedBox(height: 20),
        _buildPasswordTextField('Password', widget.passwordController),
        SizedBox(height: 20),
        _buildPasswordTextField('Retype Password', widget.retypePasswordController),
        SizedBox(height: 10),
        if (_passwordStrength.isNotEmpty)
          Text(
            _passwordStrength,
            style: TextStyle(
              color: _getColorForPasswordStrength(_passwordStrength),
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 20),
        SignUpButton(
          onPressed: () {
            if (_validateForm()) {
              // Trigger sign-up functionality
              widget.signUpCallback();
            }
          },
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

  Widget _buildTextField(String labelText, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        setState(() {
          _passwordStrength = _calculatePasswordStrength(value);
        });
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      obscureText: !_passwordVisible,
    );
  }

  String _calculatePasswordStrength(String password) {
    int score = 0;
    if (password.length < 6) return 'Weak';
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) {
      return 'Weak';
    } else if (score <= 4) {
      return 'Moderate';
    } else {
      return 'Strong';
    }
  }

  Color _getColorForPasswordStrength(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Moderate':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  bool _validateForm() {
    if (widget.nameController.text.isEmpty ||
        widget.emailController.text.isEmpty ||
        widget.contactController.text.isEmpty ||
        widget.passwordController.text.isEmpty ||
        widget.retypePasswordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields', Colors.red);
      return false;
    }

    if (widget.passwordController.text != widget.retypePasswordController.text) {
      _showSnackBar('Passwords do not match', Colors.red);
      return false;
    }

    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(widget.emailController.text);
    if (!isEmailValid) {
      _showSnackBar('Invalid email format', Colors.red);
      return false;
    }

    bool isContactValid = _validateContactNumber(widget.contactController.text);
    if (!isContactValid) {
      return false;
    }

    return true;
  }

  bool _validateContactNumber(String contactNumber) {
    if (contactNumber.isEmpty) {
      _showSnackBar('Please enter your contact number.', Colors.red);
      return false;
    }

    final flexiblePhoneNumberRegex = r'^(?:\+92)?\d{3}[-\s]?\d{7}$';

    if (!RegExp(flexiblePhoneNumberRegex).hasMatch(contactNumber)) {
      _showSnackBar('Invalid contact number format. Please enter a valid Pakistani number.', Colors.red);
      return false;
    }

    return true;
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
