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
    apiKey: 'AIzaSyB6CeYjtTB7_yuKRvF9Txx1ZTDXsu-Ml1w',
    appId: '1:647080558231:web:1f0a95ae17a2dbbe6af3d2',
    messagingSenderId: '647080558231',
    projectId: 'chat-app-81fd9',
    authDomain: 'chat-app-81fd9.firebaseapp.com',
    storageBucket: 'chat-app-81fd9.firebasestorage.app',
    measurementId: 'G-KBWSZ3N4TP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4TW2yHpa6QpDtOCFHrLuLrsD9xmvP7WA',
    appId: '1:647080558231:android:b9aa2fa948db0cd26af3d2',
    messagingSenderId: '647080558231',
    projectId: 'chat-app-81fd9',
    storageBucket: 'chat-app-81fd9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1619OgVuZVsJ1dgT5xxK9yqIJRbPlefg',
    appId: '1:647080558231:ios:fc02d5edeba254ea6af3d2',
    messagingSenderId: '647080558231',
    projectId: 'chat-app-81fd9',
    storageBucket: 'chat-app-81fd9.firebasestorage.app',
    iosBundleId: 'com.example.realchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC1619OgVuZVsJ1dgT5xxK9yqIJRbPlefg',
    appId: '1:647080558231:ios:fc02d5edeba254ea6af3d2',
    messagingSenderId: '647080558231',
    projectId: 'chat-app-81fd9',
    storageBucket: 'chat-app-81fd9.firebasestorage.app',
    iosBundleId: 'com.example.realchat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB6CeYjtTB7_yuKRvF9Txx1ZTDXsu-Ml1w',
    appId: '1:647080558231:web:77060689a6c4d8366af3d2',
    messagingSenderId: '647080558231',
    projectId: 'chat-app-81fd9',
    authDomain: 'chat-app-81fd9.firebaseapp.com',
    storageBucket: 'chat-app-81fd9.firebasestorage.app',
    measurementId: 'G-0R2M2FM690',
  );

}