import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin/user_community_logic.dart';
import 'bottom_modules.dart'; // Import your BottomModules widget
import 'basic_information.dart'; // Import your BasicInformation widget
import 'user_data.dart'; // Import your UserData model class (if applicable)
import 'fetch_user_data.dart'; // Import fetchUserData function
import 'usercommunity.dart'; // Import your CommunityPage widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  UserData? _userData; // Store fetched user data

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on initialization
  }

  Future<void> _fetchUserData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final String userId = user.uid; // Get current user ID
      try {
        final userData = await fetchUserData(userId); // Fetch data using ID
        setState(() {
          _userData = userData;
        });
      } catch (error) {
        print('Error fetching user data: $error');
        // Handle potential errors here (e.g., show a SnackBar)
      }
    } else {
      print('No user signed in, cannot fetch data.');
      // Handle case where no user is signed in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Keep the app bar color unchanged
        elevation: 4, // Increased elevation for a more pronounced shadow effect
        title: Text(
          'Constructo',
          style: TextStyle(
            color: Colors.white, // White color for the title text
            fontSize: 28, // Increased font size for better visibility
            fontWeight: FontWeight.bold, // Applied bold font weight
            fontFamily: 'Montserrat', // Updated font family to Montserrat
            letterSpacing: 1.2, // Added letter spacing for emphasis
            decoration: TextDecoration.none,
          ),
        ),
        centerTitle: true, // Centered the title horizontally
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10), // Add spacing above "Home" text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Updated text color for better contrast
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Center(
                  child: _userData != null
                      ? BasicInformation(
                    name: _userData!.name,
                    email: _userData!.email,
                    contactNumber: _userData!.contactNumber,
                  )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between BasicInformation and BottomModules
            BottomModules(
              selectedIndex: _selectedIndex,
              onModuleSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              onCommunityPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityPage(userId: '',)),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
