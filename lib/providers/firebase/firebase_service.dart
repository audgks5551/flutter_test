import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../background_tasks.dart';
import '../../firebase_options.dart';

class FireBaseService {

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> foregroundInit() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await setupFlutterNotifications();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    var token = await FirebaseMessaging.instance.getToken();
    debugPrint("fcm_token : $token");

    // 토큰이 변경될 때마다 콜백 함수가 호출되도록 리스너를 설정합니다.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint("New FCM token: $newToken");
      // 필요한 경우, 여기에서 새 토큰을 서버에 업데이트하거나 다른 작업을 수행할 수 있습니다.
    });
  }

  Future<void> backgroundInit() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await setupFlutterNotifications();
  }

  // Notification Channel 생성
  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android Notification Channel 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'notification_icon',
          ),
        ),
      );
    }
  }
}