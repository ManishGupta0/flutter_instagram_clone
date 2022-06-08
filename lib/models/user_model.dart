class UserModel {
  UserModel({
    required this.uid,
    required this.username,
    required this.fullname,
    required this.email,
    required this.bio,
    required this.latestStoryId,
    required this.profileImageUrl,
    this.followers,
    this.followings,
  });

  final String uid;
  final String username;
  final String fullname;
  final String email;
  final String bio;
  final String latestStoryId;
  final String profileImageUrl;
  final List<UserModel>? followers;
  final List<UserModel>? followings;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'fullname': fullname,
      'email': email,
      'bio': bio,
      'latestStoryId': latestStoryId,
      'profileImage': profileImageUrl,
      'followers': followers == null
          ? null
          : List<dynamic>.from(followers!.map((x) => x.toMap())),
      'followings': followings == null
          ? null
          : List<dynamic>.from(followings!.map((x) => x.toMap())),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      username: json["username"],
      fullname: json["fullname"],
      email: json["email"],
      bio: json["bio"],
      latestStoryId: json["latestStoryId"],
      profileImageUrl: json["profileImage"],
      followers: json["followers"] == null
          ? null
          : List<UserModel>.from(
              json["followers"].map(
                (x) => UserModel.fromMap(x),
              ),
            ),
      followings: json["followings"] == null
          ? null
          : List<UserModel>.from(
              json["followings"].map(
                (x) => UserModel.fromMap(x),
              ),
            ),
    );
  }
}
