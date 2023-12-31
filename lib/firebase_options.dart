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
    apiKey: 'AIzaSyBhmGIjbArD2RcHxDJMOmoVA2Axzie3_88',
    appId: '1:729834009314:web:29b12ead58bc69f67724bb',
    messagingSenderId: '729834009314',
    projectId: 'contactapplication-6de1e',
    authDomain: 'contactapplication-6de1e.firebaseapp.com',
    storageBucket: 'contactapplication-6de1e.appspot.com',
    measurementId: 'G-XRE7QWS5X3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzyfhgk49XFFmEGrGqP4j5i8EEXocLwNE',
    appId: '1:729834009314:android:aeb4900550c86e2a7724bb',
    messagingSenderId: '729834009314',
    projectId: 'contactapplication-6de1e',
    storageBucket: 'contactapplication-6de1e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQUMf4GB0SZgOjkwLwSiKQ6KEa3fuLJfo',
    appId: '1:729834009314:ios:c3165108688058247724bb',
    messagingSenderId: '729834009314',
    projectId: 'contactapplication-6de1e',
    storageBucket: 'contactapplication-6de1e.appspot.com',
    iosClientId: '729834009314-2q6pj18rg3sf1c9m0b3djp6vnvekcfes.apps.googleusercontent.com',
    iosBundleId: 'com.example.contactApp',
  );
}
