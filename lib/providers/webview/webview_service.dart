import 'dart:convert';

import 'package:farmfarm_device_server_flutter/providers/info/device_info_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../router.dart';
import '../../utils/toast/toast.dart';
import '../../utils/uuid/uuid.dart';
import '../change_notifierProviders.dart';

class WebViewService {
  late final WebViewController _controller;
  final DeviceInfoService _deviceInfoService;

  WebViewService(this._deviceInfoService) {
    _controller = createWebViewController();
  }

  WebViewController createWebViewController() {
    late final PlatformWebViewControllerCreationParams params;
    // IOS의 경우
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    }
    // IOS 이외의 경우
    else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setOnConsoleMessage((message) {
        debugPrint('== JS == ${message.level.name}: ${message.message}');
      })
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) async {
          final data = jsonDecode(message.message);
          final command = data['command'];

          // 기기 등록
          if (command == "ADD_USER_DEVICE") {
            final userDeviceKey = data['data'];

            if (isValidUUID(userDeviceKey) == false) {
              Toaster.error("관리자에게 문의해주세요");
            }

            final response = await _deviceInfoService.register(userDeviceKey);
            await RootRouter.navigatorKey.currentContext!
                .read<FCMUpdateToken>()
                .setFcmUpdateToken(response['fcmUpdateToken']);

            final fcmToken = await FirebaseMessaging.instance.getToken();
            debugPrint("fcmToken : $fcmToken");

            final fcmUpdateToken = await RootRouter.navigatorKey.currentContext!
                .read<FCMUpdateToken>()
                .token;

            final map = await _deviceInfoService.update(fcmToken!, fcmUpdateToken);
            debugPrint("=============");
            debugPrint(map.toString());
            debugPrint("=============");

            debugPrint("fcmUpdateToken : $fcmUpdateToken");

            Toaster.success("기기 등록이 완료되었습니다");

            await _controller.reload();
          }
        },
      )
      ..loadRequest(Uri.parse('http://172.30.1.20:8000'));

    // 안드로이드 앱 설정
    if (controller.platform is AndroidWebViewController) {
      // 안드로이드 디버깅 활성화
      AndroidWebViewController.enableDebugging(true);

      // 사용자의 제스처(예: 탭) 없이 미디어(예: 비디오, 오디오) 재생을 허용
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    return controller;
  }

  WebViewController get controller => _controller;
}
