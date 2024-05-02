// fetch_user_data.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_data.dart';

Future<UserData> fetchUserData(String email) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser; // Get the current user if signed in
    String? userId = user?.uid;
    // Access Firestore collection and document containing user data
    var userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    // Check if userData exists and is not null
    if (userData.exists) {
      // Parse user data from Firestore document
      return UserData.fromMap(userData.data()!);
    } else {
      // If userData does not exist, throw an error
      throw Exception('User data does not exist for email: $email');
    }
  } catch (error) {
    // Handle any errors that occur during data fetching
    throw Exception('Failed to fetch user data: $error');
  }
}
