import 'dart:convert';
import 'dart:io';
import 'package:gallery_hub_mobile_flutter/services/local_storage_service.dart';
import 'package:gallery_hub_mobile_flutter/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<http.Response> get(String endpoint) async {

    final localStorageService = LocalStorageService();
    String token = (await localStorageService.getToken())!;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: AppConstants.requestTimeOut));

      return response;

    } on SocketException {
      throw Exception('No internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? header,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers:
            header ??
            {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );

      return response;
    } on SocketException {
      throw Exception('No internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> multipartPost(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, String> headers,
    String? fileField,
    String? filePath,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    );

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.headers.addAll(headers);
    // add all json-like fields data
    request.fields.addAll(fields);

    // add file-like data to the field
    if (fileField != null && filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          filePath,
        ),
      );
    }

    try {
      final streamResponse = await request.send().timeout(const Duration(seconds: AppConstants.requestTimeOut));
      final response = await http.Response.fromStream(streamResponse);


      return response;

    } on SocketException {
      throw Exception('No internet');
    } catch (e) {
      rethrow;
    }
  
  }

}
