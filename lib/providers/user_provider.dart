import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> updateCurrentUser() async {
    _user = await AuthServices.getCurrentUser();
    notifyListeners();
  }
}
