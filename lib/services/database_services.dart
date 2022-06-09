import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/globals/constants.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/models/comment_model.dart';
import 'package:flutter_instagram_clone/services/storage_services.dart';

class DatabaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPosts({
    UserModel? user,
  }) {
    if (user != null) {
      return _firestore
          .collection(Names.postsDatabase)
          .where("user.uid", isEqualTo: user.uid)
          .snapshots();
    }

    return _firestore.collection(Names.postsDatabase).snapshots();
  }

  static Future<PostModel> getStory(UserModel user) async {
    var a = await _firestore
        .collection(Names.storyDatabase)
        .doc(user.latestStoryId)
        .get();
    return PostModel.fromMap(a.data()!);
  }

  static Future<int> getPostCommentCount(PostModel post) async {
    return (await _firestore
            .collection(Names.postsDatabase)
            .doc(post.uid)
            .collection(Names.commentCollection)
            .get())
        .size;
  }

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

      if (isStory) {
        var m = user.toMap();
        m['latestStoryId'] = postId;
        user = UserModel.fromMap(m);
      }

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

  static Future<bool> deletePost({
    required PostModel post,
    bool isStory = false,
  }) async {
    var collection = isStory ? Names.storyDatabase : Names.postsDatabase;
    try {
      await _firestore.collection(collection).doc(post.uid).delete();
      await StorageServices.deleteImage(post.postImageUrl);

      if (isStory && post.user.latestStoryId == post.uid) {
        await _firestore
            .collection(Names.usersDatabase)
            .doc(post.user.uid)
            .update({'latestStoryId': ""});
      }
      return true;
    } catch (error) {
      return throw error.toString();
    }
  }

  static Future<PostModel> togglePostLike({
    required PostModel post,
    required UserModel user,
    bool isStory = false,
  }) async {
    var collection = isStory ? Names.storyDatabase : Names.postsDatabase;
    try {
      if (post.likes.any((like) => like.uid == user.uid)) {
        await _firestore.collection(collection).doc(post.uid).update({
          "likes": FieldValue.arrayRemove([user.toMiniMap()]),
        });

        post.likes.removeWhere((element) => element.uid == user.uid);
      } else {
        await _firestore.collection(collection).doc(post.uid).update({
          "likes": FieldValue.arrayUnion([user.toMiniMap()]),
        });
        post.likes.add(user);
      }
      var snapshot =
          await _firestore.collection(collection).doc(post.uid).get();

      return PostModel.fromMap(snapshot.data()!);
    } catch (error) {
      return throw error.toString();
    }
  }

  static Future<bool> addComment({
    required PostModel post,
    required UserModel user,
    required String commentText,
    String? parentCommentId,
    bool isStory = false,
  }) async {
    var collection = isStory ? Names.storyDatabase : Names.postsDatabase;
    try {
      if (commentText.isNotEmpty) {
        var commentId = const Uuid().v1();

        var comment = CommentModel(
          uid: commentId,
          postId: post.uid,
          parentCommentId: parentCommentId ?? "",
          user: user,
          comment: commentText,
          date: DateTime.now(),
          likes: [],
        );

        await _firestore
            .collection(collection)
            .doc(post.uid)
            .collection(Names.commentCollection)
            .doc(commentId)
            .set(comment.toMap());

        return true;
      } else {
        return throw "Please enter comment";
      }
    } catch (error) {
      return throw error.toString();
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPostCommentsStream({
    required PostModel post,
    String? parentCommentId,
  }) {
    var ref = _firestore
        .collection(Names.postsDatabase)
        .doc(post.uid)
        .collection(Names.commentCollection);

    if (parentCommentId != null && parentCommentId.isNotEmpty) {
      return ref
          .where("parentCommentId", isEqualTo: parentCommentId)
          .snapshots();
    }

    return ref.where("parentCommentId", isEqualTo: "").snapshots();
  }

  static Future<bool> toggleCommentLike({
    required CommentModel comment,
    required UserModel user,
  }) async {
    try {
      // already liked
      if (comment.likes.any((element) => element.uid == user.uid)) {
        await _firestore
            .collection(Names.postsDatabase)
            .doc(comment.postId)
            .collection(Names.commentCollection)
            .doc(comment.uid)
            .update({
          "likes": FieldValue.arrayRemove([user.toMiniMap()]),
        });
      } else {
        // new like
        await _firestore
            .collection(Names.postsDatabase)
            .doc(comment.postId)
            .collection(Names.commentCollection)
            .doc(comment.uid)
            .update(
          {
            "likes": FieldValue.arrayUnion([user.toMiniMap()]),
          },
        );
      }

      return true;
    } catch (error) {
      return throw error.toString();
    }
  }

  static Future<bool> toggleUserFollow({
    required UserModel user,
    required UserModel follow,
  }) async {
    try {
      // already following
      if (user.followings!.any((element) => element.uid == follow.uid)) {
        await _firestore.collection(Names.usersDatabase).doc(user.uid).update(
          {
            "followings": FieldValue.arrayRemove([follow.toMiniMap()]),
          },
        );

        await _firestore.collection(Names.usersDatabase).doc(follow.uid).update(
          {
            "followers": FieldValue.arrayRemove([user.toMiniMap()]),
          },
        );
      }
      // follow now
      else {
        await _firestore.collection(Names.usersDatabase).doc(user.uid).update(
          {
            "followings": FieldValue.arrayUnion([follow.toMiniMap()]),
          },
        );
        await _firestore.collection(Names.usersDatabase).doc(follow.uid).update(
          {
            "followers": FieldValue.arrayUnion([user.toMiniMap()]),
          },
        );
      }
      return true;
    } catch (error) {
      return throw error.toString();
    }
  }

  static Future<List<UserModel>> getUserSuggestions(UserModel user) async {
    var followings = user.followings!.map((e) => e.uid).toList();

    var query = _firestore.collection(Names.usersDatabase).where(
          "uid",
          isNotEqualTo: user.uid,
        );

    var snapshot = await query.get();

    return snapshot.docs.map((e) => UserModel.fromMap(e.data())).toList()
      ..retainWhere((element) => !followings.contains(element.uid));
  }
}
