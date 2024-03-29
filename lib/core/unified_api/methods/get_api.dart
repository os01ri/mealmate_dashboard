import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../helper/helper_functions.dart';
import '../handling_exception_request.dart';

typedef FromJson<T> = T Function(String body);

class GetApi<T> with HandlingExceptionRequest {
  final Uri uri;
  final FromJson fromJson;
  final Map? body;
  final bool getFCMToken;

  GetApi({
    required this.uri,
    required this.fromJson,
    this.body = const {},
    this.getFCMToken = false,
  });
  Future<T> callRequest() async {
    String? token = await HelperFunctions.getToken();
    String fcmToken = await HelperFunctions.getFCMToken(getFCMToken: getFCMToken);
    bool isAuth = await HelperFunctions.isAuth();
    String? deviceId = "";
    if (getFCMToken) {
      // deviceId = await HelperFunctions.getDeviceId(); TODO: uncomment
    }
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if(!kIsWeb)
          'fcm_token': fcmToken,
        if (isAuth) 'Authorization': 'Bearer $token',
        if (getFCMToken) "device_id": deviceId,
      };
      var request = http.Request('GET', uri);
      request.body = jsonEncode(body);
      request.headers.addAll(headers);
      http.StreamedResponse streamedResponse =
          await request.send().timeout(const Duration(seconds: 20));
      http.Response response = await http.Response.fromStream(streamedResponse);
      log(response.body);
      if (response.statusCode == 200) {
        return fromJson(response.body);
      } else {
        Exception exception = getException(response: response);
        throw exception;
      }
    } on HttpException {
      log(
        'http exception',
        name: 'RequestManager get function',
      );
      rethrow;
    } on FormatException {
      log(
        'something went wrong in parsing the uri',
        name: 'RequestManager get function',
      );
      rethrow;
    } on SocketException {
      log(
        'socket exception',
        name: 'RequestManager get function',
      );
      rethrow;
    } catch (e) {
      log(
        e.toString(),
        name: 'RequestManager get function',
      );
      rethrow;
    }
  }
}
