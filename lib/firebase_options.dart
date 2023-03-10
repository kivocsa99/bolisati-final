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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz8ejjqegiNQTTb6TjPgKm_TzPXBG7mbI',
    appId: '1:515681658668:android:56bb4c593278e04719ae89',
    messagingSenderId: '515681658668',
    projectId: 'gammabolisati',
    storageBucket: 'gammabolisati.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDG3tgZYEzabe4c924r4JjfrX_Edv0YQAo',
    appId: '1:515681658668:ios:018a8aaf64c20bce19ae89',
    messagingSenderId: '515681658668',
    projectId: 'gammabolisati',
    storageBucket: 'gammabolisati.appspot.com',
    androidClientId: '515681658668-qgvmplubga08feiokba4ljhjo916g6ch.apps.googleusercontent.com',
    iosClientId: '515681658668-l390ijhiug9dson3genpps6040016v4a.apps.googleusercontent.com',
    iosBundleId: 'com.bolisati.bolisati',
  );
}
