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
    apiKey: 'AIzaSyDLd3Jj8utafJnb1WRlC6S8NRsQUihoc4s',
    appId: '1:603274710993:web:6f22b3946c20e8f862daf0',
    messagingSenderId: '603274710993',
    projectId: 'injury-recovery',
    authDomain: 'injury-recovery.firebaseapp.com',
    storageBucket: 'injury-recovery.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZffkmwvATvARvtzKgAj3PST9Z_iSNJkg',
    appId: '1:603274710993:android:42b0bd722e7b37b462daf0',
    messagingSenderId: '603274710993',
    projectId: 'injury-recovery',
    storageBucket: 'injury-recovery.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZmEtLfjwbNEfi4QwLBzE2F89TaXiEWTg',
    appId: '1:603274710993:ios:4097d293791ff56b62daf0',
    messagingSenderId: '603274710993',
    projectId: 'injury-recovery',
    storageBucket: 'injury-recovery.appspot.com',
    iosBundleId: 'com.example.injuryRecovery',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZmEtLfjwbNEfi4QwLBzE2F89TaXiEWTg',
    appId: '1:603274710993:ios:5d61e6ace703e02462daf0',
    messagingSenderId: '603274710993',
    projectId: 'injury-recovery',
    storageBucket: 'injury-recovery.appspot.com',
    iosBundleId: 'com.example.injuryRecovery.RunnerTests',
  );
}
