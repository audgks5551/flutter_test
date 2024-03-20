import 'dart:async';
import 'dart:developer' as developer;

import 'package:farmfarm_device_server_flutter/app.dart';
import 'package:farmfarm_device_server_flutter/init.dart';
import 'package:farmfarm_device_server_flutter/providers/change_notifierProviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runZonedGuarded(() {

    WidgetsFlutterBinding.ensureInitialized();

    initLocator();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FCMUpdateToken()),
        ],
        child: const App(),
      ),
    );
  }, (dynamic error, dynamic stack) {
    developer.log("에러!!", error: error, stackTrace: stack);
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("관리자에게 문의해주세요."),
          ),
        ),
      ),
    );
  });
}


