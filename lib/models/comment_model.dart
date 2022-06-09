import 'package:flutter_instagram_clone/models/user_model.dart';

class CommentModel {
  CommentModel({
    required this.uid,
    required this.postId,
    required this.parentCommentId,
    required this.comment,
    required this.user,
    required this.date,
    required this.likes,
  });

  final String uid;
  final String postId;
  final String? parentCommentId;
  final String comment;
  final UserModel user;
  final DateTime date;
  final List<UserModel> likes;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'postId': postId,
      'parentCommentId': parentCommentId,
      'user': user.toMiniMap(),
      'comment': comment,
      'date': date.toIso8601String(),
      'likes': likes.map((e) => e.toMiniMap()).toList(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uid: map['uid'],
      postId: map['postId'],
      parentCommentId: map['parentCommentId'],
      comment: map['comment'],
      user: UserModel.fromMap(map['user']),
      date: DateTime.parse(map['date']),
      likes: List<UserModel>.from(
        map['likes'].map(
          (x) => UserModel.fromMap(x),
        ),
      ),
    );
  }
}
