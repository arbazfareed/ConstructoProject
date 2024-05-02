import 'comment.dart'; // Import the Comment class
import 'package:intl/intl.dart'; // Import the intl package

class Post {
  final String postId;
  final String userId;
  final String userName; // Define the userName parameter
  final String title;
  final String content;
  final String imageUrl;
  final DateTime timestamp;
  final String postTime;
  final List<Comment> comments; // Add a field for comments

  Post({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    this.imageUrl = '',
    required this.timestamp,
    required this.postTime,
    List<Comment>? comments, // Add a parameter for comments
  }) : comments = comments ?? []; // Initialize comments with an empty list if not provided

  // Define a factory method to create Post instance from map
  factory Post.fromMap(Map<String, dynamic> map) {
    // Convert list of maps representing comments to list of Comment objects
    List<Comment> postComments = (map['comments'] as List<dynamic>).map((commentMap) => Comment.fromMap(commentMap)).toList();

    return Post(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
      postTime: map['postTime'] ?? '',
      comments: postComments, // Initialize with converted list of comments
    );
  }
}
