import 'package:farmfarm_device_server_flutter/services/device_info_api.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'providers/firebase/firebase_service.dart';
import 'providers/info/device_info_service.dart';
import 'providers/webview/webview_service.dart';

GetIt locator = GetIt.instance;

void initLocator() {
  // service
  locator.registerLazySingleton<UserDeviceInfoApi>(() => UserDeviceInfoApi());

  // provider
  locator.registerLazySingleton<FireBaseService>(() => FireBaseService());
  locator.registerLazySingleton<DeviceInfoService>(
          () => DeviceInfoService(locator<UserDeviceInfoApi>()));
  locator.registerLazySingleton<WebViewService>(
          () => WebViewService(locator<DeviceInfoService>()));
}
