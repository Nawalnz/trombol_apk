// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBvYPGoywarE1FfbIxyOtICxvghYJTjeME',
    appId: '1:1035035035608:web:d28c2fea110aa2eecfd4ad',
    messagingSenderId: '1035035035608',
    projectId: 'trombol-db',
    authDomain: 'trombol-db.firebaseapp.com',
    storageBucket: 'trombol-db.firebasestorage.app',
    measurementId: 'G-82CDY7KWGP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHh49RC_CmF7TgzJNCXLgaa4lOq_UdwsQ',
    appId: '1:1035035035608:android:793e2d94e7d4bf15cfd4ad',
    messagingSenderId: '1035035035608',
    projectId: 'trombol-db',
    storageBucket: 'trombol-db.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDT8xPl1r0dtzXqSMbAa0OmX1XxgckZBj8',
    appId: '1:1035035035608:ios:92119c7a10d7b774cfd4ad',
    messagingSenderId: '1035035035608',
    projectId: 'trombol-db',
    storageBucket: 'trombol-db.firebasestorage.app',
    iosBundleId: 'com.example.trombolApk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDT8xPl1r0dtzXqSMbAa0OmX1XxgckZBj8',
    appId: '1:1035035035608:ios:92119c7a10d7b774cfd4ad',
    messagingSenderId: '1035035035608',
    projectId: 'trombol-db',
    storageBucket: 'trombol-db.firebasestorage.app',
    iosBundleId: 'com.example.trombolApk',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBvYPGoywarE1FfbIxyOtICxvghYJTjeME',
    appId: '1:1035035035608:web:412224c01f0aeea3cfd4ad',
    messagingSenderId: '1035035035608',
    projectId: 'trombol-db',
    authDomain: 'trombol-db.firebaseapp.com',
    storageBucket: 'trombol-db.firebasestorage.app',
    measurementId: 'G-WD8MKBFH1B',
  );
}
