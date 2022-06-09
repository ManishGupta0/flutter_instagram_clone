import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/widgets/follow_button.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';
import 'package:flutter_instagram_clone/pages/account_page.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileBubble(
        user: user,
        width: 60,
        withText: false,
      ),
      title: Text(user.username),
      subtitle: Text(user.fullname),
      trailing: FollowButton(user: user),
      onTap: () {
        Navigator.push(
          context,
          CustomPageRoute.fromRight(
            child: AccountPage(user: user),
          ),
        );
      },
    );
  }
}
