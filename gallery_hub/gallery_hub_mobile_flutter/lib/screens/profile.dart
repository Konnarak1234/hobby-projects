import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/services/local_storage_service.dart';

class ProfileScreen extends StatelessWidget {

  void logout() async{
      final localStorageService = LocalStorageService();
      localStorageService.clearUser();
  }

  @override
  Widget build(BuildContext context){
  

    return Scaffold(body: Center(child: TextButton(onPressed: logout, child: Text('Logout')),));
  }
}