import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FCMUpdateToken with ChangeNotifier, DiagnosticableTreeMixin {
  final _FCM_UPDATE_TOKEN_KEY = 'fcmUpdateToken';
  final _storage = const FlutterSecureStorage();
  String _token = "";

  FCMUpdateToken() {
    _init();
  }

  Future<void> _init() async {
    _token = await _storage.read(key: _FCM_UPDATE_TOKEN_KEY) ?? "";
  }

  String get token => _token;

  Future<void> setFcmUpdateToken(String fcmUpdateToken) async {
    await _storage.write(key: _FCM_UPDATE_TOKEN_KEY, value: fcmUpdateToken);

    _token = await _storage.read(key: _FCM_UPDATE_TOKEN_KEY) ?? "";
    notifyListeners();
  }

  Future<void> resetFcmUpdateToken() async{
    await _storage.delete(key: _FCM_UPDATE_TOKEN_KEY);
    _token = await _storage.read(key: _FCM_UPDATE_TOKEN_KEY) ?? "";
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('fcmUpdateToken', token));
  }
}