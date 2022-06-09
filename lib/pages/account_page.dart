import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late UserProvider _userProvider;
  late TabController _tabController;
  bool _isLoggingOut = false;
  final ValueNotifier<bool> _showUserSuggestions = ValueNotifier(true);

  int postCount = 0;

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  void logout() async {
    setState(() => _isLoggingOut = true);
    await AuthServices.logOutUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(widget.user.username),
        actions: [
          // action buttons for current user
          if (_userProvider.getUser.uid == widget.user.uid) ...[
            IconButton(
              splashRadius: 1,
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  CustomPageRoute.fromDown(
                    child: Container(),
                  ),
                );
              },
            ),
            IconButton(
              splashRadius: 1,
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ]
          // action button for other users
          else ...[
            IconButton(
              splashRadius: 1,
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              splashRadius: 1,
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ProfileBubble(
                      user: widget.user,
                      withText: false,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("$postCount"),
                      const Text("Posts"),
                    ],
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("${widget.user.followers!.length}"),
                        const Text("Followers"),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("${widget.user.followings!.length}"),
                        const Text("Following"),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // user name below profile pic
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.user.fullname,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // for current user
                if (_userProvider.getUser.uid == widget.user.uid) ...[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white54,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text("Edit Profile"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white54,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showUserSuggestions.value =
                            !_showUserSuggestions.value;
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(Icons.person_add),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white54,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text("Message"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white54,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text("Email address"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white54,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showUserSuggestions.value =
                              !_showUserSuggestions.value;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(Icons.person_add),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (_userProvider.getUser.uid == widget.user.uid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white54,
                        ),
                      ),
                      child: InkWell(
                        onTap: _isLoggingOut
                            ? null
                            : () {
                                logout();
                              },
                        child: Container(
                          width: double.infinity,
                          height: 32,
                          alignment: Alignment.center,
                          child: _isLoggingOut
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Log out"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // user suggestions
          ValueListenableBuilder<bool>(
            valueListenable: _showUserSuggestions,
            builder: (_, value, __) {
              if (value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text("Discover People"),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          10,
                          (index) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              margin: const EdgeInsets.only(right: 4),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),

          const SizedBox(height: 24),
          // tabbar
          SizedBox(
            height: 40,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 1,
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused)
                      ? null
                      : Colors.transparent;
                },
              ),
              tabs: const [
                Icon(Icons.grid_on_sharp),
                Icon(Icons.play_arrow_outlined),
                Icon(Icons.assignment_ind_outlined),
              ],
            ),
          ),
          // tab view
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ...List.generate(
                  3,
                  (index) => GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    children: [
                      ...List.generate(
                        120,
                        (index) => Container(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
