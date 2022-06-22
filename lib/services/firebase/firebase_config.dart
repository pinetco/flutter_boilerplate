import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:123258444350:android:1e6889d131d89785fc0f6f',
        apiKey: 'AIzaSyDUrHTWDF4tidPsV0tuHX8PEeh8kKUf8Ts',
        projectId: 'flutter-boilerplate-b4218',
        messagingSenderId: '123258444350',
        iosBundleId: 'com.example.flutter_boilerplate',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:123258444350:android:1e6889d131d89785fc0f6f',
        apiKey: 'AIzaSyDUrHTWDF4tidPsV0tuHX8PEeh8kKUf8Ts',
        projectId: 'flutter-boilerplate-b4218',
        messagingSenderId: '123258444350',
      );
    }
  }
}
