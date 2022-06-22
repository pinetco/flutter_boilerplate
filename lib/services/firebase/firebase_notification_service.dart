import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../config.dart';
import 'firebase_config.dart';

//when app in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterAppBadger.isAppBadgeSupported().then((value) {
    FlutterAppBadger.updateBadgeCount(1);
  });
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseNotificationService {
  static Future<bool> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions,
    );

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return true;
  }

  setup() {
    initNotification();
  }

  Future<void> initNotification() async {
    //when app is [closed | killed | terminated]
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _notificationNavigateToItemDetail(message.data);
      }
    });

    //for IOS
    Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      /*showDialog(
        context: Get.context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title ?? ''),
          content: Text(body ?? ''),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {
                print------Log("IOS Ok Notification Click");
              },
            ),
          ],
        ),
      );*/
    }

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_notification');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (val) async {
      if (val != null && val.isNotEmpty) {
        dynamic data = jsonDecode(val);
        _notificationNavigateToItemDetail(data);
      }
    });

    //when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      removeBadge();
      RemoteNotification? notification = message.notification;

      if (!kIsWeb && notification != null) {
        String? channelId;
        channelId = message.notification!.android?.channelId;

        String? currentRoute = Get.currentRoute;
        if (currentRoute.contains('messenger')) {
        } else {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId ?? channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'ic_notification',
                color: const Color(0xFF6EBAE7),
              ),
              iOS: const IOSNotificationDetails(),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      removeBadge();
      _notificationNavigateToItemDetail(message.data);
    });

    getToken();
  }

  void _notificationNavigateToItemDetail(dynamic data) async {
    if (!isNullOrBlank(data)) {
      if (data["screen"] != null) {
        if (data['data'] != null) {
          dynamic newData;
          if (data['data'] is String) {
            newData = jsonDecode(data['data']);
          } else {
            newData = data['data'];
          }

          Get.toNamed('/${data['screen']}', arguments: newData);
        } else {
          Get.toNamed('/${data['screen']}');
        }
      }
    }
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    printLog("::: token : $token");
  }

  requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void addBadge(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  void removeBadge() {
    FlutterAppBadger.removeBadge();
  }
}
