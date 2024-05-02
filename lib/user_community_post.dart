import 'package:flutter/material.dart';
import 'package:flutter_signin/post.dart' as SignInPost;
import 'fetch_user_data.dart';
import 'user_data.dart';
import 'comment.dart';

class PostList extends StatelessWidget {
  final String? userId;
  final UserData? userData;
  final Function(SignInPost.Post, String) submitComment;

  const PostList({
    Key? key,
    required this.userId,
    required this.userData,
    required this.submitComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your widget tree here
    return Container(); // Placeholder container for now
  }
}
