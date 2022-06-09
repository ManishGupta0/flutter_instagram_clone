import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/widgets/user_list_tile.dart';

class FollowingsPage extends StatelessWidget {
  const FollowingsPage({
    Key? key,
    this.initialIndex = 0,
    required this.user,
  }) : super(key: key);

  final UserModel user;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.username),
          bottom: TabBar(
            tabs: [
              Text("${user.followers!.length} followers"),
              Text("${user.followings!.length} following"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _tabview(user.followers!),
            _tabview(user.followings!),
          ],
        ),
      ),
    );
  }

  Widget _tabview(List<UserModel> data) {
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (_, index) {
        return UserListTile(user: data.elementAt(index));
      },
    );
  }
}
