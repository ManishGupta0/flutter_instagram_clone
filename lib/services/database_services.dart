import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/globals/constants.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/services/storage_services.dart';

class DatabaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<PostModel> upload({
    required UserModel user,
    required Uint8List image,
    required String description,
    bool isStory = false,
  }) async {
    var collection = isStory ? Names.storyDatabase : Names.postsDatabase;
    var imageDir = isStory ? Names.storyStorage : Names.postStorage;

    try {
      var downloadUrl = await StorageServices.uploadImage(imageDir, image);

      var postId = const Uuid().v1();

      var post = PostModel(
        uid: postId,
        user: user,
        postImageUrl: downloadUrl,
        description: description,
        date: DateTime.now(),
        likes: [],
      );

      await _firestore.collection(collection).doc(postId).set(post.toMap());

      if (isStory) {
        await _firestore
            .collection(Names.usersDatabase)
            .doc(user.uid)
            .update({'latestStoryId': postId});
      }

      return post;
    } catch (error) {
      return throw error.toString();
    }
  }
}
