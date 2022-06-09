import 'package:flutter_instagram_clone/models/user_model.dart';

class PostModel {
  PostModel({
    required this.uid,
    required this.user,
    required this.postImageUrl,
    required this.description,
    required this.date,
    required this.likes,
  });

  final String uid;
  final UserModel user;
  final String postImageUrl;
  final String description;
  final DateTime date;
  final List<UserModel> likes;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user': user.toMiniMap(),
      'postImageUrl': postImageUrl,
      'description': description,
      'date': date.toIso8601String(),
      'likes': likes.map((e) => e.toMiniMap()).toList(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'],
      user: UserModel.fromMap(map['user']),
      postImageUrl: map['postImageUrl'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      likes: List<UserModel>.from(
        map['likes'].map(
          (x) => UserModel.fromMap(x),
        ),
      ),
    );
  }
}
