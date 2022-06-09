import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/widgets/follow_button.dart';
import 'package:flutter_instagram_clone/pages/account_page.dart';

class UserSuggestionCard extends StatelessWidget {
  const UserSuggestionCard({
    Key? key,
    required this.user,
    this.size,
    this.onDismiss,
  }) : super(key: key);

  final UserModel user;
  final double? size;
  final Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CustomPageRoute.fromRight(
            child: AccountPage(user: user),
          ),
        );
      },
      child: Container(
        width: size ?? 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                      user.profileImageUrl,
                    ),
                  ),
                ),
                InkWell(
                  child: const Icon(Icons.close),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(user.fullname),
            const SizedBox(height: 8),
            const Text("Suggested for You"),
            const SizedBox(height: 16),
            FollowButton(user: user),
          ],
        ),
      ),
    );
  }
}
