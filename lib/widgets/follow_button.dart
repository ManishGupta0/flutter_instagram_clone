import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isLoading = false;
  bool _isFollowing = true;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    _isFollowing = _userProvider.getUser.followings!
        .any((element) => element.uid == widget.user.uid);
  }

  void followUser() async {
    setState(() => _isLoading = true);

    DatabaseServices.toggleUserFollow(
      user: _userProvider.getUser,
      follow: widget.user,
    ).then((value) {
      _userProvider.updateCurrentUser().then(
        (value) {
          setState(() {
            _isLoading = false;
            _isFollowing = !_isFollowing;
          });
        },
      );
    }).catchError((error) {
      setState(() => _isLoading = false);
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userProvider.getUser.uid == widget.user.uid) {
      return const SizedBox();
    }
    return _isFollowing
        ? OutlinedButton(
            onPressed: _isLoading
                ? null
                : () {
                    followUser();
                  },
            child: !_isLoading
                ? const Text("Following")
                : const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
          )
        : ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    followUser();
                  },
            child: !_isLoading
                ? const Text("Follow")
                : const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
          );
  }
}
