import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/globals/constants.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/services/storage_services.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel> getCurrentUser() async {
    var snap = await _firestore
        .collection(Names.usersDatabase)
        .doc(_auth.currentUser!.uid)
        .get();

    return UserModel.fromMap(snap.data()!);
  }

  static Future<UserModel> signUpUser({
    required String username,
    required String fullname,
    required String email,
    required String password,
    required String bio,
    required Uint8List? imageBytes,
  }) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          fullname.isNotEmpty) {
        // create user
        var cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadPath = "";
        if (imageBytes != null) {
          // upload profile image
          downloadPath = await StorageServices.uploadImage(
            Names.userStorage,
            imageBytes,
          );
        }

        var user = UserModel(
          uid: cred.user!.uid,
          username: username,
          fullname: fullname,
          email: email,
          bio: bio,
          latestStoryId: "",
          profileImageUrl: downloadPath,
          followers: [],
          followings: [],
        );

        // add user to database
        await _firestore
            .collection(Names.usersDatabase)
            .doc(cred.user!.uid)
            .set(user.toMap());

        return user;
      } else {
        return throw "Please enter all the fields";
      }
    } catch (error) {
      return throw error.toString();
    }
  }

  static Future<UserModel> logInUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        return getCurrentUser();
      } else {
        return throw "Please enter all the fields";
      }
    } catch (error) {
      return throw error.toString();
    }
  }

  static Future<void> logOutUser() async {
    await _auth.signOut();
  }

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
