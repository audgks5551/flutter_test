import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UserDeviceInfoApi {
  Future<Response> registerDeviceApi(
      String userDeviceKey, String name, String identifier) async {
    return await http
        .post(
          Uri.parse('http://172.30.1.20:8000/api/v1/users/devices'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'identifier': identifier,
            'userDeviceKey': userDeviceKey,
          }),
        );
  }

  Future<Response> updateUserDeviceApi(
      String userDeviceId, String fcmToken, String fcmUpdateToken) async {
    return await http
        .post(
      Uri.parse('http://172.30.1.20:8000/api/v1/users/devices/$userDeviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fcmToken': fcmToken,
        'fcmUpdateToken': fcmUpdateToken,
      }),
    );
  }
}
