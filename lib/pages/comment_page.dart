import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/models/comment_model.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/widgets/comment_card.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late UserProvider _userProvider;
  final ValueNotifier<CommentModel?> _replyTo = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addComment(String commentText) async {
    DatabaseServices.addComment(
      post: widget.post,
      user: _userProvider.getUser,
      commentText: commentText,
      parentCommentId: _replyTo.value == null ? null : _replyTo.value!.uid,
    ).then((value) {}).catchError((error) {
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Comments"),
        actions: [
          Transform.rotate(
            angle: -math.pi / 6,
            child: IconButton(
              icon: const Icon(Icons.send_outlined),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                CommentCard(
                  post: widget.post,
                  isHeader: true,
                  comment: CommentModel(
                    uid: "",
                    postId: widget.post.uid,
                    parentCommentId: "",
                    user: widget.post.user,
                    comment: widget.post.description,
                    date: widget.post.date,
                    likes: widget.post.likes,
                  ),
                ),
                const Divider(),
                StreamBuilder<QuerySnapshot>(
                  stream: DatabaseServices.getPostCommentsStream(
                    post: widget.post,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    return Column(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            var data = document.data()! as Map<String, dynamic>;
                            var comment = CommentModel.fromMap(data);
                            return CommentCard(
                              indent: 1,
                              post: widget.post,
                              comment: comment,
                              isLiked: comment.likes.any(
                                (element) =>
                                    element.uid == _userProvider.getUser.uid,
                              ),
                              onReply: (comment) {
                                _replyTo.value = comment;
                              },
                            );
                          })
                          .toList()
                          .cast(),
                    );
                  },
                ),
              ],
            ),
          ),
          ValueListenableBuilder<CommentModel?>(
            valueListenable: _replyTo,
            builder: (context, value, chid) {
              return Column(
                children: [
                  if (value == null) const SizedBox(),
                  if (value != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.white12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reply to ${value.user.username}"),
                          CloseButton(
                            onPressed: () {
                              _replyTo.value = null;
                            },
                          ),
                        ],
                      ),
                    ),
                  CommentInput(
                    user: _userProvider.getUser,
                    onSubmit: addComment,
                    replyTo: value,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CommentInput extends StatefulWidget {
  const CommentInput({
    Key? key,
    required this.user,
    this.replyTo,
    this.onSubmit,
  }) : super(key: key);

  final CommentModel? replyTo;
  final UserModel user;
  final Function(String)? onSubmit;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white12,
      child: Row(
        children: [
          ProfileBubble(
            user: widget.user,
            width: 40,
            withText: false,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: widget.replyTo == null
                    ? "Add a comment..."
                    : "Add a reply...",
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: _commentController.text.isEmpty
                ? null
                : () {
                    widget.onSubmit?.call(_commentController.text);
                    _commentController.clear();
                  },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }
}
