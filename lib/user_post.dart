import 'package:flutter/material.dart';
import 'user_data.dart';
import 'post.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Define fetchUserName as a top-level function
Future<String> fetchUserName(String userId) async {
  try {
    // Get a reference to the user document in Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Check if the user document exists and the data is not null
    if (userSnapshot.exists && userSnapshot.data() != null) {
      // Cast userSnapshot.data() to Map<String, dynamic>
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      // Access the 'name' field from the user document and return it
      return userData['name'] ?? 'Unknown';
    } else {
      return 'Unknown'; // Return a default value if the user document does not exist or data is null
    }
  } catch (e) {
    print('Error fetching user name: $e');
    return 'Unknown'; // Return a default value in case of error
  }
}
