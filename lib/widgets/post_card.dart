import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_instagram_clone/utils/date_utils.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/pages/account_page.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';
import 'package:flutter_instagram_clone/widgets/pulse_animation.dart';
import 'package:flutter_instagram_clone/pages/comment_page.dart';
import 'package:flutter_instagram_clone/pages/likes_page.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.post,
    this.onMenu,
  }) : super(key: key);

  final PostModel post;
  final Function()? onMenu;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _isHeartAnimating = false;

  bool _canLike = true;

  bool _isBookmarked = false;
  late UserProvider _userProvider;

  int commentCount = 0;

  void getCommentCount() async {
    var len = await DatabaseServices.getPostCommentCount(widget.post);
    setState(() => commentCount = len);
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void likePost() async {
    if (!_isLiked) {
      togglePostLike();
    }
  }

  void togglePostLike() {
    setState(() => _canLike = false);

    DatabaseServices.togglePostLike(
      post: widget.post,
      user: _userProvider.getUser,
    ).then((value) {
      setState(() => _canLike = true);
    }).catchError((error) {
      setState(() => _canLike = true);
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    getCommentCount();
    _isLiked = widget.post.likes
        .any((element) => element.uid == _userProvider.getUser.uid);
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Row(
            children: [
              ProfileBubble(
                user: widget.post.user,
                width: 40,
                withText: false,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(widget.post.user.username)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CustomPageRoute.fromRight(
                        child: AccountPage(user: widget.post.user),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                splashRadius: 1,
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  widget.onMenu?.call();
                },
              ),
            ],
          ),
        ),
        // Image
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.post.postImageUrl,
                  fit: BoxFit.cover,
                ),
                Opacity(
                  opacity: _isHeartAnimating ? 1 : 0,
                  child: PulseAnimation(
                    isAnimating: _isHeartAnimating,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.favorite, size: 100),
                    onEnd: () => setState(() => _isHeartAnimating = false),
                  ),
                ),
              ],
            ),
            onDoubleTap: () {
              setState(() => _isHeartAnimating = true);
              likePost();
            },
          ),
        ),
        // Like, Comment, Share
        Row(
          children: [
            PulseAnimation(
              isAnimating: _isLiked,
              alwaysAnimate: true,
              child: IconButton(
                splashRadius: 1,
                splashColor: Colors.transparent,
                color: _isLiked ? Colors.red : null,
                icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  if (_canLike) togglePostLike();
                },
              ),
            ),
            IconButton(
              splashRadius: 1,
              icon: const Icon(Icons.comment_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  CustomPageRoute.fromRight(
                    child: CommentPage(
                      post: widget.post,
                    ),
                  ),
                );
              },
            ),
            Transform.rotate(
              angle: -math.pi / 6,
              child: IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {},
              ),
            ),
            Flexible(child: Container()),
            PulseAnimation(
              isAnimating: _isBookmarked,
              alwaysAnimate: true,
              child: IconButton(
                splashRadius: 1,
                splashColor: Colors.transparent,
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                ),
                onPressed: () {
                  setState(() => _isBookmarked = !_isBookmarked);
                },
              ),
            ),
          ],
        ),
        // Like Count, Description, time
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text("${widget.post.likes.length} Likes"),
                onTap: () {
                  Navigator.push(
                    context,
                    CustomPageRoute.fromRight(
                      child: LikesPage(likes: widget.post.likes),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: widget.post.user.username,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            CustomPageRoute.fromRight(
                              child: AccountPage(user: widget.post.user),
                            ),
                          );
                        },
                    ),
                    TextSpan(
                      text: " ${widget.post.description}",
                    ),
                  ],
                ),
              ),
              if (commentCount > 0) const SizedBox(height: 4),
              if (commentCount > 0)
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text("View all $commentCount comments"),
                  onTap: () {
                    Navigator.push(
                      context,
                      CustomPageRoute.fromRight(
                        child: CommentPage(
                          post: widget.post,
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 4),
              Text(MyDateUtils.dateAgo(widget.post.date)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
