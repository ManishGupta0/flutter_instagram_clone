import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/models/comment_model.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/utils/date_utils.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';
import 'package:flutter_instagram_clone/widgets/pulse_animation.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    Key? key,
    this.indent = 0,
    this.isHeader = false,
    this.isLiked = false,
    required this.post,
    required this.comment,
    this.onReply,
  }) : super(key: key);

  final int indent;
  final bool isHeader;
  final bool isLiked;
  final PostModel post;
  final CommentModel comment;
  final Function(CommentModel)? onReply;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final double _itemSize = 50;
  late UserProvider _userProvider;

  final ValueNotifier<bool> _showReplies = ValueNotifier(false);
  final ValueNotifier<bool> _isLiked = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void toggleCommentLike() async {
    DatabaseServices.toggleCommentLike(
      comment: widget.comment,
      user: _userProvider.getUser,
    ).then((value) {
      _isLiked.value = !_isLiked.value;
    }).catchError((error) {
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    _isLiked.value = widget.isLiked;

    return Container(
      margin: EdgeInsets.only(
        left: max(_itemSize * widget.indent, 10),
        bottom: 12,
        top: 12,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // probile pic
              ProfileBubble(
                width: _itemSize - widget.indent * 0.1 * _itemSize,
                user: widget.comment.user,
                withText: false,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header / comment
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: widget.comment.user.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: " ${widget.comment.comment}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // timespan, likes, reply
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // timespan
                        Text(
                          MyDateUtils.dateAgo(widget.comment.date),
                          style: const TextStyle(color: Colors.white54),
                        ),
                        if (!widget.isHeader) ...[
                          const SizedBox(width: 12),
                          // likes
                          Text(
                            "${widget.comment.likes.length} likes",
                            style: const TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(width: 12),
                          // reply
                          GestureDetector(
                            child: const Text(
                              "Reply",
                              style: TextStyle(color: Colors.white54),
                            ),
                            onTap: () {
                              widget.onReply?.call(widget.comment);
                            },
                          ),
                        ],
                      ],
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: DatabaseServices.getPostCommentsStream(
                        post: widget.post,
                        parentCommentId: widget.comment.uid,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.hasData &&
                            snapshot.data!.size > 0 &&
                            !widget.isHeader) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: _showReplies,
                            builder: (_, value, __) => !value
                                ? Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 50,
                                            child: Expanded(
                                              child: Divider(),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            child: Text(
                                              "View ${snapshot.data!.size} more Reply",
                                              style: const TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                            onTap: () {
                                              _showReplies.value = true;
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
              if (!widget.isHeader)
                PulseAnimation(
                  isAnimating: _isLiked.value,
                  alwaysAnimate: true,
                  child: IconButton(
                    splashRadius: 1,
                    splashColor: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    color: _isLiked.value ? Colors.red : null,
                    icon: Icon(
                      _isLiked.value ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                    ),
                    onPressed: () {
                      toggleCommentLike();
                    },
                  ),
                ),
            ],
          ),
          // Replies
          ValueListenableBuilder<bool>(
            valueListenable: _showReplies,
            builder: (_, value, __) => value
                ? Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: DatabaseServices.getPostCommentsStream(
                          post: widget.post,
                          parentCommentId: widget.comment.uid,
                        ),
                        builder: ((context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  var data =
                                      document.data()! as Map<String, dynamic>;
                                  var c = CommentModel.fromMap(data);
                                  return CommentCard(
                                    indent: 1,
                                    post: widget.post,
                                    comment: CommentModel.fromMap(data),
                                    isLiked: c.likes.any(
                                      (element) =>
                                          element.uid ==
                                          _userProvider.getUser.uid,
                                    ),
                                  );
                                })
                                .toList()
                                .cast(),
                          );
                        }),
                      ),
                      // Hide Replies
                      Row(
                        children: [
                          SizedBox(
                            width: _itemSize -
                                widget.indent * 0.1 * _itemSize +
                                12,
                          ),
                          const SizedBox(
                            width: 50,
                            child: Expanded(
                              child: Divider(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            child: const Text(
                              "Hide Replies",
                              style: TextStyle(color: Colors.white54),
                            ),
                            onTap: () {
                              _showReplies.value = false;
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
