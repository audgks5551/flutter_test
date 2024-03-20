import 'package:farmfarm_device_server_flutter/init.dart';
import 'package:farmfarm_device_server_flutter/providers/webview/webview_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<HomeScreen> {
  final webViewService = locator<WebViewService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: webViewService.controller),
      ),
    );
  }
}
