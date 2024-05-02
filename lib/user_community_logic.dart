import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_data.dart';
import 'fetch_user_data.dart';
import 'bottom_modules.dart';
import 'comment.dart';

class CommunityPage extends StatefulWidget
{
  final String userId;

  const CommunityPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
{
  int _selectedIndex = 1;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  UserData? _userData;
  bool _postSubmitted = false;
  String _submittedPostText = '';
  List<XFile> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await fetchUserData(widget.userId);
      setState(() {
        _userData = userData;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }



  Future<void> submitPost(String userId, String postTitle, String postText, List<XFile> imageFiles) async {
    DateTime now = DateTime.now();

    try {
      // Upload images to Firebase Storage concurrently
      List<Future<String>> uploadTasks = imageFiles.map((file) async {
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String imagePath = 'images/$userId/$timestamp.jpg';
        final ref = FirebaseStorage.instance.ref().child(imagePath);
        await ref.putFile(File(file.path));
        return await ref.getDownloadURL();
      }).toList();

      final uploadedImageUrls = await Future.wait(uploadTasks);

      // Submit post to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': userId,
        'title': postTitle.isNotEmpty ? postTitle : 'Title of the new post',
        'content': postText,
        'timestamp': now,
        'imageUrls': uploadedImageUrls,
      });

      // Optionally, update the UI or navigate to a different screen after post submission
    } catch (error) {
      print('Error submitting post: $error');
      // Handle error as needed
    }
  }



  Future<void> _uploadImagesAndSubmitPost() async {
    final picker = ImagePicker();

    try {
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        _imageFiles = pickedFiles;
        // Display selected images or thumbnails
      } else {
        print('No images selected.');
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }


  void _submitPost(String postTitle) async
  {
    String postText = _textEditingController.text;

    try {
      await submitPost(widget.userId, postTitle, postText, _imageFiles);
      setState(() {
        _postSubmitted = true;
        _submittedPostText = postText;
        _imageFiles.clear();
      });
      _titleController.clear();
      _textEditingController.clear();
    } catch (error) {
      print('Error submitting post: $error');
      // Handle error as needed
    }
  }



  void _submitTextPost() {
    String postTitle = _titleController.text;
    String postText = _textEditingController.text;

    if (postText.isNotEmpty) {
      _submitPost(postTitle);
    } else {
      // Show an error message or handle empty post text case
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Constructo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreatePostSection(),
            Divider(),
            PostList(userId: widget.userId, userData: _userData),
          ],
        ),
      ),
      bottomNavigationBar: BottomModules(
        selectedIndex: _selectedIndex,
        onModuleSelected: _onItemTapped,
        onCommunityPressed: () {},
      ),
    );
  }



  Widget _buildCreatePostSection()
  {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Create Post',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),

            child: ElevatedButton.icon(
              onPressed: () async {
                // Show a message indicating the upload is in progress
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Uploading images...')),
                );

                try {
                  // Call the function to upload images
                  await _uploadImagesAndSubmitPost();

                  // Show a message indicating the upload is complete
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Images uploaded successfully')),
                  );
                } catch (error) {
                  // Show a message indicating upload failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload images')),
                  );
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Upload Image(s)'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding for touchable area
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),


          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),

            child:ElevatedButton(
              onPressed: _submitTextPost,
              child: Text('Post'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Adjust padding for touchable area
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4, // Add elevation for subtle hover or press effect
              ),
            ),

          ),
          if (_postSubmitted)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleController.text.isNotEmpty ? _titleController.text : 'Title of the new post',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _submittedPostText,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        break;
      default:
        break;
    }
  }
}

class UserCommunityPost {
  final String title;
  final String content;
  final DateTime? timestamp;
  final List<String> imageUrls; // Add this property

  UserCommunityPost({
    required this.title,
    required this.content,
    required this.timestamp,
    required this.imageUrls, // Initialize in the constructor
  });

  factory UserCommunityPost.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCommunityPost(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []), // Initialize from document data
    );
  }
}

class PostCard extends StatefulWidget {
  final UserCommunityPost post;
  final UserData? userData;
  final List<Comment>? comments;

  const PostCard({Key? key, required this.post, this.userData, this.comments}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}


class PostList extends StatelessWidget {
  final String userId;
  final UserData? userData;

  const PostList({Key? key, required this.userId, required this.userData}) : super(key: key);


  @override
  Widget build(BuildContext context)

  {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs.map((doc) => UserCommunityPost.fromDocument(doc)).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post, userData: userData);
          },
        );
      },
    );
  }
}


class _PostCardState extends State<PostCard> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String username = widget.userData?.name ?? 'Unknown User';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.post.title.isNotEmpty) Text(widget.post.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.post.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            if (widget.post.timestamp != null) Text(DateFormat.yMMMMd().add_jm().format(widget.post.timestamp!), style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text(username),
            SizedBox(height: 8),
            if (widget.post.imageUrls.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.post.imageUrls.length,
                itemBuilder: (context, index) {
                  String imageUrl = widget.post.imageUrls[index];
                  return Image.network(imageUrl, height: 100, width: 100);
                },
              ),
            SizedBox(height: 8),
            if (widget.comments != null && widget.comments!.isNotEmpty)
              _buildCommentList(widget.comments!),
            SizedBox(height: 8),
            _buildUserInteraction(), // Add user interaction UI
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList(List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((comment) => _buildComment(comment)).toList(),
    );
  }

  Widget _buildComment(Comment comment) {
    return Container(
      margin: EdgeInsets.only(left: comment.isReply ? 32 : 0),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.userName),
          SizedBox(height: 4),
          Text(comment.content),
          SizedBox(height: 4),
          if (comment.commentTime != null) Text(comment.commentTime!, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          _buildReplyButton(comment), // Pass comment to reply button
        ],
      ),
    );
  }

  Widget _buildReplyButton(Comment comment) {
    return TextButton(
      onPressed: () {
        // Logic for replying to a comment
        _replyToComment(comment);
      },
      child: Text('Reply'),
    );
  }

  Widget _buildUserInteraction() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _submitComment,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _replyToComment(Comment comment) {
    // Implement reply functionality
    // You can open a modal or navigate to a new screen to compose a reply
    // Pass the selected comment to the reply screen/modal
  }

  void _submitComment() {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      // Format the current timestamp
      String commentTime = DateFormat.yMMMMd().add_jm().format(DateTime.now());

      // Create a new Comment object
      Comment newComment = Comment(
        commentId: '', // Placeholder, will be replaced after submission
        userId: widget.userData!.userId,
        userName: widget.userData!.name,
        content: commentText,
        timestamp: DateTime.now(),
        commentTime: commentTime,
        isReply: false,
      );

      // Optimistic UI update: Add the new comment to the list immediately
      setState(() {
        if (widget.comments != null) {
          widget.comments!.add(newComment);
        }
        _commentController.clear();
      });

      // Interact with backend to submit the comment
      FirebaseFirestore.instance
          .collection('comments')
          .add(newComment.toMap()) // Convert comment to a map
          .then((docRef) {
        // Update the commentId with the generated ID from Firestore
        newComment = newComment.copyWith(commentId: docRef.id);

        // Update the comments list and UI
        setState(() {
          if (widget.comments != null) {
            final index = widget.comments!.indexWhere((comment) => comment == newComment);
            if (index != -1) {
              widget.comments![index] = newComment;
            }
          }
        });
      })
          .catchError((error) {
        // Revert the optimistic UI update if there's an error
        setState(() {
          if (widget.comments != null) {
            widget.comments!.remove(newComment);
          }
        });

        print('Error submitting comment: $error');
        // Handle errors (e.g., display an error message to the user)
      });
    }
  }

}