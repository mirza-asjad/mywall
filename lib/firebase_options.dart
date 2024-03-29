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
    apiKey: 'AIzaSyBxLVY1-Kw3fu5t3ynbfb7LmCLQF7ZXH18',
    appId: '1:371186637002:web:b5e518f9b90f635cfd3c33',
    messagingSenderId: '371186637002',
    projectId: 'mywall-2b42a',
    authDomain: 'mywall-2b42a.firebaseapp.com',
    storageBucket: 'mywall-2b42a.appspot.com',
    measurementId: 'G-WFNHHPGF7D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCI9lQef-TmRexsu-p6axEaylTchoHJklA',
    appId: '1:371186637002:android:e552d9f676a65f2cfd3c33',
    messagingSenderId: '371186637002',
    projectId: 'mywall-2b42a',
    storageBucket: 'mywall-2b42a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcO6hQyBIMDWAisgyXZOxnZuGrO4mr1Qk',
    appId: '1:371186637002:ios:fc06149579fadb8bfd3c33',
    messagingSenderId: '371186637002',
    projectId: 'mywall-2b42a',
    storageBucket: 'mywall-2b42a.appspot.com',
    iosBundleId: 'com.example.mywall',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcO6hQyBIMDWAisgyXZOxnZuGrO4mr1Qk',
    appId: '1:371186637002:ios:78e55fc5172a0f9afd3c33',
    messagingSenderId: '371186637002',
    projectId: 'mywall-2b42a',
    storageBucket: 'mywall-2b42a.appspot.com',
    iosBundleId: 'com.example.mywall.RunnerTests',
  );
}
