import 'package:flutter/material.dart';
import 'user_data.dart'; // Import your UserData model class
import 'post_list.dart'; // Import the PostList widget
import 'post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  UserData? userData; // Define userData
  bool _postSubmitted = false; // Define postSubmitted flag

  Future<String> fetchUserName(String userId) async {
    try {
      // Reference to the users collection in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Get the document snapshot for the specified user ID
      DocumentSnapshot snapshot = await users.doc(userId).get();

      // Check if the document exists
      if (snapshot.exists) {
        // If the document exists, extract the user name and return it
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown User';
      } else {
        // If the document doesn't exist, return a default name or an empty string
        return 'Unknown User';
      }
    } catch (e) {
      // Handle any errors that occur during the fetching process
      print('Error fetching user data: $e');
      return 'Unknown User';
    }
  }

  // Method to submit a comment
  void _submitComment(Post post, String commentText) {
    // Implement the logic to submit a comment
    // This could involve updating the post's comments list, etc.
    print('Submitting comment: $commentText');
  }

  @override
  Widget build(BuildContext context) {
    // Build your UI, including the PostList widget
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      // body: PostList(
      //   userData: userData, // Provide the user data
      //   postSubmitted: _postSubmitted, // Provide the postSubmitted flag
      //   fetchUserName: fetchUserName, // Provide the fetchUserName function
      //   submitComment: _submitComment, // Provide the submitComment function
      // ),
    );
  }
}
