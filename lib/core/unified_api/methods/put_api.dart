import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../helper/helper_functions.dart';
import '../handling_exception_request.dart';

typedef FromJson<T> = T Function(String body);

class PutApi<T> with HandlingExceptionRequest {
  final Uri uri;
  final Map body;
  final FromJson fromJson;
  final bool isLogin;
  final Duration timeout;

  const PutApi({
    required this.uri,
    required this.body,
    required this.fromJson,
    this.isLogin = false,
    this.timeout = const Duration(seconds: 60),
  });

  Future<T> callRequest() async {
    String? token = await HelperFunctions.getToken();
    String fcmToken = await HelperFunctions.getFCMToken();
    bool isAuth = await HelperFunctions.isAuth();

    log('the token in the request header is $token', name: 'request manager ==> put function ');
    log("$body", name: 'request body');
    try {
      var headers = {
        'Content-Type': 'application/json',
        if(!kIsWeb)
          'fcm_token': fcmToken,
        'Accept': 'application/json',
        if (isAuth) 'Authorization': 'Bearer $token',
      };

      var request = http.Request('PUT', uri);
      request.body = jsonEncode(body);
      request.headers.addAll(headers);
      http.StreamedResponse streamedResponse = await request.send().timeout(timeout);
      log(request.body, name: "request body");
      print(request.body);
      http.Response response = await http.Response.fromStream(streamedResponse);
      log(response.body);
      print(response.body);

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return fromJson(response.body);
      } else {
        Exception exception = getException(response: response);
        throw exception;
      }
    } on HttpException {
      log(
        'http exception',
        name: 'RequestManager put function',
      );
      rethrow;
    } on FormatException {
      log(
        'something went wrong in parsing the uri',
        name: 'RequestManager put function',
      );
      rethrow;
    } on SocketException {
      log(
        'socket exception',
        name: 'RequestManager put function',
      );
      rethrow;
    } catch (e) {
      log(
        e.toString(),
        name: 'RequestManager put function',
      );
      rethrow;
    }
  }
}
