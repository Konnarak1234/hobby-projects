import 'dart:convert';
import 'dart:io';
import 'package:gallery_hub_mobile_flutter/models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final url = Uri.http('10.0.2.2:8000', 'api/login');
  late User user;
  late String errorMessage;

  Future<bool> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        url,
        body: {'email': email, 'password': password},
      );
      final bodyData = jsonDecode(response.body) as Map<String, dynamic>;

      // response
      if (response.statusCode == 401) {
        errorMessage = bodyData['message']!;
        return false;
      }

      user = User(
        id: bodyData['user']['id'],
        name: bodyData['user']['name'],
        email: bodyData['user']['email'],
        authToken: bodyData['token'],
      );

      return true;

      // if the request won't reach server
    } on SocketException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}
