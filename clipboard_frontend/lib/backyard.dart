import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';

const String DOMAIN = 'http://localhost:7860'; // do NOT include trailing slash

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
  Dio dio = Dio();
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

