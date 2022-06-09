import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late UserProvider currentUser;
  bool _isLoading = true;
  late PostModel post;

  void getLatestStory() async {
    setState(() => _isLoading = true);

    DatabaseServices.getStory(widget.user).then((value) {
      setState(() => _isLoading = false);
      post = value;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<UserProvider>(context, listen: false);
    getLatestStory();
  }

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(120),
      borderSide: Divider.createBorderSide(
        context,
        width: 1,
        color: Colors.white54,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Main Content Image
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                post.postImageUrl,
                              ),
                            ),
                          ),
                        ),
                        // Progress bar
                        const Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: LinearProgressIndicator(
                            value: 0.4,
                            minHeight: 2,
                            color: Colors.white,
                            backgroundColor: Colors.white54,
                          ),
                        ),
                        // Profile Info
                        Positioned(
                          top: 20,
                          left: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileBubble(
                                user: widget.user,
                                width: 40,
                                withText: false,
                              ),
                              const SizedBox(width: 12),
                              Text(widget.user.username),
                              const SizedBox(width: 12),
                              const Text("10 s"),
                            ],
                          ),
                        ),
                        // close button
                        Positioned(
                          top: 20,
                          right: 0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                              backgroundColor: Colors.black54,
                              primary: Colors.white,
                            ),
                            child: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.user.uid == currentUser.getUser.uid)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          storyActionButton(
                            Icons.share_outlined,
                            "Share to...",
                          ),
                          storyActionButton(Icons.facebook, "Facebook"),
                          storyActionButton(Icons.favorite_border, "Highlight"),
                          storyActionButton(Icons.more_vert, "More"),
                        ],
                      ),
                    ),
                  if (widget.user.uid != currentUser.getUser.uid)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: outlineBorder,
                                focusedBorder: outlineBorder,
                                enabledBorder: outlineBorder,
                                contentPadding: const EdgeInsets.all(12),
                                hintText: "Send message",
                              ),
                            ),
                          ),
                          IconButton(
                            splashRadius: 1,
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                          IconButton(
                            splashRadius: 1,
                            icon: const Icon(Icons.send),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget storyActionButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(text),
        ],
      ),
    );
  }
}
