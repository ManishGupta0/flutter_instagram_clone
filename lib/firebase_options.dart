// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDKM0URBtLjMPIw8yCLUQN_M16ueySCBSY',
    appId: '1:4558334772:web:1e2c274da465c1b85a5361',
    messagingSenderId: '4558334772',
    projectId: 'flutter-instagram-clone-69d55',
    authDomain: 'flutter-instagram-clone-69d55.firebaseapp.com',
    storageBucket: 'flutter-instagram-clone-69d55.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBo_oi_YhevSRVAyzSLvWj5GjlDGo_Sdio',
    appId: '1:4558334772:android:911d20c6905fb6695a5361',
    messagingSenderId: '4558334772',
    projectId: 'flutter-instagram-clone-69d55',
    storageBucket: 'flutter-instagram-clone-69d55.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVgLdj2TmKbPKiK_JLyfI4HIchXTqlM6c',
    appId: '1:4558334772:ios:dda576f51d49c6535a5361',
    messagingSenderId: '4558334772',
    projectId: 'flutter-instagram-clone-69d55',
    storageBucket: 'flutter-instagram-clone-69d55.appspot.com',
    iosClientId: '4558334772-n4qpkukc8jm9fa98llkb91uj7h53pqou.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterInstagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVgLdj2TmKbPKiK_JLyfI4HIchXTqlM6c',
    appId: '1:4558334772:ios:dda576f51d49c6535a5361',
    messagingSenderId: '4558334772',
    projectId: 'flutter-instagram-clone-69d55',
    storageBucket: 'flutter-instagram-clone-69d55.appspot.com',
    iosClientId: '4558334772-n4qpkukc8jm9fa98llkb91uj7h53pqou.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterInstagramClone',
  );
}