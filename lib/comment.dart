import 'package:intl/intl.dart'; // Import the intl package

class Comment {
  final String commentId;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final String commentTime;
  final bool isReply; // Add the isReply property

  Comment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    required this.commentTime,
    required this.isReply, // Initialize isReply property
  });

  // Define a factory method to create Comment instance from map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
      commentTime: map['commentTime'] ?? '',
      isReply: map['isReply'] ?? false, // Initialize isReply property
    );
  }

  // Convert Comment object to a map
  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'commentTime': commentTime,
      'isReply': isReply,
    };
  }

  // Define a copyWith method to create a new Comment object with updated properties
  Comment copyWith({
    String? commentId,
    String? userId,
    String? userName,
    String? content,
    DateTime? timestamp,
    String? commentTime,
    bool? isReply,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      commentTime: commentTime ?? this.commentTime,
      isReply: isReply ?? this.isReply,
    );
  }
}

