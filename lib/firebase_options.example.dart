
// Copy to firebase_options.dart for local builds (demo mode works with placeholders).
// Run `flutterfire configure` for production Firebase keys.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: '301384322009',
    projectId: 'nekosensei-9a95c',
    authDomain: 'nekosensei-9a95c.firebaseapp.com',
    storageBucket: 'nekosensei-9a95c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzLifoxFVVQ-CNScmk9YUPebBfRgMZXtw',
    appId: '1:301384322009:android:b7383ccfa046da2e8c67c8',
    messagingSenderId: '301384322009',
    projectId: 'nekosensei-9a95c',
    storageBucket: 'nekosensei-9a95c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '301384322009',
    projectId: 'nekosensei-9a95c',
    storageBucket: 'nekosensei-9a95c.firebasestorage.app',
    iosBundleId: 'com.nekosensei.app',
  );
}
