import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/widgets/logo.dart';
import 'package:flutter_instagram_clone/widgets/loading_overlay.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/widgets/post_card.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';
import 'package:flutter_instagram_clone/pages/add_page_layout.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of(context, listen: false);
  }

  void deletePost(PostModel post) async {
    LoadingOverlay.of(context).show();

    DatabaseServices.deletePost(post: post).then((result) {
      LoadingOverlay.of(context).hide();
      Navigator.pop(context);
    }).catchError((error) {
      showSnackBar(error.toString());
    });
  }

  void showMenu(PostModel post) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Icon(Icons.remove),
              if (post.user.uid == userProvider.getUser.uid) ...[
                const ListTile(
                  title: Text("Post to other apps..."),
                  enabled: false,
                ),
                const ListTile(title: Text("Share to..."), enabled: false),
                const ListTile(title: Text("Copy link"), enabled: false),
                const ListTile(title: Text("Archive"), enabled: false),
                ListTile(
                  title: const Text("Delete"),
                  onTap: () => deletePost(post),
                ),
                const ListTile(title: Text("Edit"), enabled: false),
                const ListTile(title: Text("Hide like count"), enabled: false),
                const ListTile(
                    title: Text("Turn off commenting"), enabled: false),
              ],
              if (post.user.uid != userProvider.getUser.uid) ...const [
                ListTile(title: Text("Report..."), enabled: false),
                ListTile(
                  title: Text("Why you're seeing this post"),
                  enabled: false,
                ),
                ListTile(title: Text("Add to favourites"), enabled: false),
                ListTile(title: Text("Hide"), enabled: false),
                ListTile(title: Text("About this account"), enabled: false),
                ListTile(title: Text("Sharre to..."), enabled: false),
                ListTile(title: Text("Copy link"), enabled: false),
                ListTile(title: Text("Unfollow"), enabled: false),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Logo(),
        actions: [
          IconButton(
            splashRadius: 1,
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            splashRadius: 1,
            icon: const Icon(Icons.send_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // stories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // current user story
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ProfileBubble(
                    user: userProvider.getUser,
                    withAddButton: true,
                    text: "Your Story",
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute.fromRight(
                          child: const AddPageLayout(startingPage: 2),
                        ),
                      );
                    },
                  ),
                ),
                // other stories
                ...userProvider.getUser.followings!
                    .where((element) => element.latestStoryId.isNotEmpty)
                    .toList()
                    .map(
                  (user) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ProfileBubble(
                        user: user,
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(thickness: 1),
          // posts
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: DatabaseServices.getPosts(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  var e = PostModel.fromMap(
                    snapshot.data!.docs[index].data(),
                  );

                  return PostCard(
                    post: e,
                    onMenu: () {
                      showMenu(e);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
