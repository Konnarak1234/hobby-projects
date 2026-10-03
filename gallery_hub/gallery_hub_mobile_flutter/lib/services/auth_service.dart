import 'dart:convert';
import 'package:gallery_hub_mobile_flutter/models/user.dart';
import 'package:gallery_hub_mobile_flutter/services/api_service.dart';
import 'package:gallery_hub_mobile_flutter/services/local_storage_service.dart';

class AuthService {
  final url = Uri.http('10.0.2.2:8000', 'api/login');
  final localStorageService = LocalStorageService();
  final apiService = ApiService();
  late User user;
  late String errorMessage;

  Future<bool> loginUser(String email, String password) async {
    try {
      final response = await apiService.post('login', {'email': email, 'password': password});
      // every reponse body data will be json, include error message
      // reasons: api is written in laravel, which will return error message in json, when client http expected json response
      final bodyData = jsonDecode(response.body) as Map<String, dynamic>;
      // response
      if (response.statusCode == 401) {
        errorMessage = bodyData['message']!;
        return false;
      } else if(response.statusCode == 422) {
        errorMessage = bodyData['message'];
        return false;
      }

      user = User(
        id: bodyData['user']['id'],
        name: bodyData['user']['name'],
        email: bodyData['user']['email'],
        authToken: bodyData['token'],
      );

      await localStorageService.saveUser(userId: user.id, name: user.name, token: user.authToken);

      return true;

      // if the request won't reach server
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}
