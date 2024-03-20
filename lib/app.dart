import 'package:flutter/material.dart';

import 'init.dart';
import 'providers/firebase/firebase_service.dart';
import 'router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final fireBaseService = locator<FireBaseService>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await fireBaseService.foregroundInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RootRouter.routerConfig,
    );
  }
}