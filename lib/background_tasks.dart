import 'package:firebase_messaging/firebase_messaging.dart';

import 'init.dart';
import 'providers/firebase/firebase_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  initLocator();

  final FireBaseService fireBaseService = locator<FireBaseService>();
  await fireBaseService.backgroundInit();

  fireBaseService.showFlutterNotification(message);
}