import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:farmfarm_device_server_flutter/services/device_info_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final UserDeviceInfoApi _userDeviceInfoApi;
  final _USER_DEVICE_ID = 'user_device_id';
  final _storage = const FlutterSecureStorage();
  DeviceInfo? _deviceInfo;

  DeviceInfoService(this._userDeviceInfoApi) {
    _init();
  }

  Future<void> _init() async {
    if (TargetPlatform.android == defaultTargetPlatform) {
      _deviceInfo =
          await _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      return;
    }

    throw PlatformException(code: 'ERROR', message: '지원하지 않는 기기입니다.');
  }

  Future<DeviceInfo> _readAndroidBuildData(AndroidDeviceInfo build) async {
    String? identifier = await AndroidId().getId();
    final userDeviceId = await _storage.read(key: _USER_DEVICE_ID) ?? "";

    return DeviceInfo.fromJson(<String, String>{
      'user_device_id': userDeviceId,
      'model': build.model,
      'identifier': identifier!,
    });
  }

  Future<Map<String, dynamic>> register(String userDeviceKey) async {
    Map<String, dynamic> map = await _userDeviceInfoApi.registerDeviceApi(
      userDeviceKey,
      _deviceInfo!.model,
      _deviceInfo!.identifier,
    );

    await _storage.write(key: _USER_DEVICE_ID, value: map['userDeviceId']);

    return map;
  }

  Future<Map<String, dynamic>> update(String fcmToken, String fcmUpdateToken) async {
    final userDeviceId = await _storage.read(key: _USER_DEVICE_ID) ?? "";
    Map<String, dynamic> map = await _userDeviceInfoApi.updateUserDeviceApi(
      userDeviceId,
      fcmToken,
      fcmUpdateToken,
    );

    return map;
  }

  DeviceInfo get deviceInfo => _deviceInfo!;
}

class DeviceInfo {
  final String model;
  final String identifier;

  DeviceInfo({
    required this.model,
    required this.identifier,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      model: json['model'],
      identifier: json['identifier'],
    );
  }
}
