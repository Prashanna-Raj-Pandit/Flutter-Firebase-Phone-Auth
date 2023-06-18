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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA7WlZG2Lg6ofPYtjiDmXZ2OKjeEAX1WrI',
    appId: '1:342580245956:web:988fdb6a283e5387be6091',
    messagingSenderId: '342580245956',
    projectId: 'phoneauthflutter-12d7d',
    authDomain: 'phoneauthflutter-12d7d.firebaseapp.com',
    storageBucket: 'phoneauthflutter-12d7d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSwfdn9Ge693HBbcBXngIh6ny7QJ6-jAE',
    appId: '1:342580245956:android:5f9c08e556443602be6091',
    messagingSenderId: '342580245956',
    projectId: 'phoneauthflutter-12d7d',
    storageBucket: 'phoneauthflutter-12d7d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwCu4pnhm8gsYOhhdG-CClWa2cHvQa8KI',
    appId: '1:342580245956:ios:3c12d4bd65063e94be6091',
    messagingSenderId: '342580245956',
    projectId: 'phoneauthflutter-12d7d',
    storageBucket: 'phoneauthflutter-12d7d.appspot.com',
    iosClientId: '342580245956-lu6n6396icrclvajer8gtg38a6lvu0vb.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebasePhoneAuth',
  );
}