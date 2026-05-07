import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Configure com os valores do seu projeto Firebase.
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
      default:
        throw UnsupportedError('Plataforma não configurada para Firebase.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBc0dQl07jE-VsopTVUVguvpCQ6adu-g0w',
    appId: '1:845233394720:web:e76d88c05d2308df585845',
    messagingSenderId: '845233394720',
    projectId: 'ponto-444b1',
    authDomain: 'ponto-444b1.firebaseapp.com',
    storageBucket: 'ponto-444b1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'COLE_ANDROID_API_KEY',
    appId: 'COLE_ANDROID_APP_ID',
    messagingSenderId: 'COLE_SENDER_ID',
    projectId: 'ponto-444b1',
    storageBucket: 'ponto-444b1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'COLE_IOS_API_KEY',
    appId: 'COLE_IOS_APP_ID',
    messagingSenderId: 'COLE_SENDER_ID',
    projectId: 'ponto-444b1',
    storageBucket: 'ponto-444b1.firebasestorage.app',
    iosBundleId: 'com.example.pontoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'COLE_MACOS_API_KEY',
    appId: 'COLE_MACOS_APP_ID',
    messagingSenderId: 'COLE_SENDER_ID',
    projectId: 'ponto-444b1',
    storageBucket: 'ponto-444b1.firebasestorage.app',
    iosBundleId: 'com.example.pontoApp',
  );
}
