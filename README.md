# flutter_instagram_clone

Instagram Clone built with flutter and firebase

Works on Android, IOS and Web


## Features
- Responsive UI
- Email & Password Authentication with Firebase
- Share Post
- Share Story
- Like & Comment on Post
- Follow User
- Feed Page
- Account Page

## Getting Started
#### 1. Setup [Flutter](https://flutter.dev/docs/get-started/install)
#### 2. Clone the repo

```bash
git clone https://github.com/ManishGupta0/flutter_instagram_clone.git
cd flutter_instagram_clone/
```

#### 3. Setup the firebase app
1. Setup Firebase Project following instructions at https://console.firebase.google.com
2. Enable Email/Password Authentication
3. Enable Firebase Database
4. Create Flutter app on Firebase
5. Follow instruction to register app to firebase

#### 4. Run the following commands to run your app:
```bash
  flutter pub get
  flutter run
```

## Packages Used
- [firebase_core](https://pub.dev/packages/firebase_core)
- [firebasse_auth](https://pub.dev/packages/firebase_auth)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [firebase_storage](https://pub.dev/packages/firebase_storage)
- [uuid](https://pub.dev/packages/uuid)
- [provider](https://pub.dev/packages/provider)
- [image_picker](https://pub.dev/packages/image_picker)
- [flutter_svg](https://pub.dev/packages/flutter_svg)
- [cached_network_image](https://pub.dev/packages/cached_network_image)
- [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view)

# What's Next?
 - Notificaitons for likes, comments, follows, etc
 - Caching of Profiles, Images, Etc.
 - Add filters to story images
 - Firebase Security Rules
 - Direct Messaging
 - Shop
 - Video posts
 - Better Animation
 - Code clean up
