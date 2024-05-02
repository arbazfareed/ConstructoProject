// import 'package:flutter/material.dart';
// import 'user_data.dart';
// import 'post.dart';
//
//
// class PostList extends StatelessWidget
// {
//   final UserData? userData;
//   final bool postSubmitted;
//   final Future<String> Function(String) fetchUserName;
//   final void Function(Post, String) submitComment;
//
//   const PostList({
//     Key? key,
//     required this.userData,
//     required this.postSubmitted,
//     required this.fetchUserName,
//     required this.submitComment,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildPostList();
//   }
//
//   Widget _buildPostList() {
//     return userData != null && userData!.posts.isNotEmpty
//         ? ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: userData!.posts.length,
//       itemBuilder: (context, index) {
//         final post = userData!.posts[index];
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               title: Text(post.title),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(post.content),
//                   SizedBox(height: 4),
//                   FutureBuilder<String>(
//                     future: fetchUserName(post.userId),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       }
//                       if (snapshot.hasError) {
//                         return Text('Error fetching user name');
//                       }
//                       final userName = snapshot.data!;
//                       return Text(
//                         'Posted by: $userName',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               onTap: () {
//                 // Uncomment and implement logic to view post details
//                 Navigator.pushNamed(context, '/postDetails', arguments: post);
//               },
//             ),
//             SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Comments (${post.comments.length})',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // Uncomment and implement logic to open comment section
//                       Navigator.pushNamed(context, '/comments', arguments: post);
//                     },
//                     child: Text('View all'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 8),
//             ...post.comments.map((comment) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(comment.content),
//                     SizedBox(height: 4),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             // Implement logic to like the comment
//                             // updateLikeStatus(comment);
//                             print('Like comment');
//                           },
//                           icon: Icon(Icons.thumb_up),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             // Implement logic to reply to the comment
//                             submitComment(post, comment.commentId);
//                           },
//                           icon: Icon(Icons.reply),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//             Divider(),
//           ],
//         );
//       },
//     )
//         : Center(
//       child: userData == null
//           ? CircularProgressIndicator()
//           : postSubmitted
//           ? SizedBox.shrink()
//           : Text('No posts yet'),
//     );
//   }
// }