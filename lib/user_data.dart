import 'post.dart'; // Import the Post class

class UserData {
  final String userId; // Add userId property

  final String name;
  final String email;
  final String contactNumber;
 // final List<Post> posts;

  UserData({
    required this.userId, // Initialize userId in the constructor
    required this.name,
    required this.email,
    required this.contactNumber,
 //   required this.posts,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    // List<Post> userPosts = (map['posts'] as List<dynamic>).map((postMap) => Post.fromMap(postMap)).toList();

    return UserData(
      userId: map['userId'] ?? '', // Assign userId from map data
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
    //  posts: userPosts,
    );
  }
}
