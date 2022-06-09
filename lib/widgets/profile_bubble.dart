import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_instagram_clone/globals/themes.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';

class ProfileBubble extends StatelessWidget {
  const ProfileBubble({
    Key? key,
    this.withAddButton = false,
    this.withText = false,
    this.width = 75,
    this.backgroundColor = Colors.black,
    this.text,
    required this.user,
    this.onTap,
  }) : super(key: key);

  final bool withAddButton;
  final bool withText;
  final double width;
  final Color backgroundColor;
  final String? text;
  final UserModel user;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var withBorder = user.latestStoryId.isNotEmpty;

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      focusColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // gradient border
                if (withBorder)
                  Container(
                    width: width,
                    height: width,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.red,
                          Colors.orange,
                        ],
                      ),
                    ),
                  ),
                // main image container
                Container(
                  width: width - 4,
                  height: width - 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: withBorder ? backgroundColor : Colors.transparent,
                      width: 4,
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // add story button
                if (withAddButton)
                  Positioned(
                    bottom: width * 0.025,
                    right: width * 0.025,
                    child: Container(
                      width: width * 0.25,
                      height: width * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: backgroundColor,
                      ),
                      child: Icon(
                        Icons.add_circle,
                        color: blueColor,
                        size: width * 0.25,
                      ),
                    ),
                  ),
              ],
            ),
            if (withText) SizedBox(height: withBorder ? 8 : 12),
            if (withText)
              Text(
                text ?? user.username,
                overflow: TextOverflow.ellipsis,
              )
          ],
        ),
      ),
    );
  }
}
