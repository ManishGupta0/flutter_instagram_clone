import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/widgets/follow_button.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({
    Key? key,
    required this.likes,
  }) : super(key: key);

  final List<UserModel> likes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Likes"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...likes.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  ProfileBubble(
                    user: user,
                    width: 64,
                    withText: false,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.username),
                        Text(user.fullname),
                      ],
                    ),
                  ),
                  FollowButton(user: user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
