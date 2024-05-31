import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

const String DOMAIN = 'https://mujtaba-io-clipboard.hf.space'; // do NOT include trailing slash

Dio dio = Dio();

String makeUrl(String path) {
  if (path.startsWith('/')) {
    return '$DOMAIN$path';
  } else {
    return '$DOMAIN/$path';
  }
}

// Replace 'your_api_endpoint' with the actual endpoint URL
Future<dynamic> fetchData(
    {required String endpoint, Map<String, dynamic>? data}) async {
  try {
    Response response;
    if (data != null) {
      // POST request with data
      response = await dio.post(endpoint, data: data);
    } else {
      // GET request (same logic from previous example)
      response = await dio.get(endpoint);
    }
    if (response.statusCode == 200) {
      // Parse the JSON response and convert to a Map with String keys
      return jsonDecode(response.data);
    } else {
      // Handle error based on status code
      throw Exception(
          'API request failed with status code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    // Handle Dio specific errors
    throw Exception('API request failed: ${e.message}');
  }
}

/*
usage:
import 'package:clipboard/backyard.dart';
fetchData(endpoint: makeUrl('api/clipboard')).then((data) {
  print(data);
}).catchError((e) {
  print(e);
});
*/

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

Future<String> getClipboardText() async {
  ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
  if (clipboardData != null) {
    return clipboardData.text ?? '';
  } else {
    return '';
  }
}

//
//
//
//
//

const int MAX_TEXT_SIZE = 32 * 1024; // 32 KB
const int MAX_PIN_SIZE = 32; // 32 bytes
const int MAX_FILE_SIZE = 32 * 1024 * 1024; // 32 MB

const int MIN_PIN_SIZE = 4; // 4 bytes