import 'dart:convert';
import 'dart:io';
import 'package:gallery_hub_mobile_flutter/model/user.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final url = Uri.https('localhost');
  late User user;
  late String errorMessage;

  Future<bool> loginUser(String email, String password) async{
    try{
      final response = await http.post(url, body: {'email': email, 'password': password});
      final bodyData = jsonDecode(response.body) as Map<String, dynamic>;

      // response
      if(response.statusCode == 400) {     
        errorMessage = bodyData['message']!;
        return false;
      }
      

      user = User(id: bodyData['id'], name: bodyData['name'], email: bodyData['email'], authToken: bodyData['token']);

      return true;
    
    // if the request won't reach server
    } on SocketException catch(e) {
      errorMessage = e.message;
      return false;
    } catch(e) {
      errorMessage = 'Request time out';
      return false;
    }
    

  }
}