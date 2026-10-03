
import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/screens/home.dart';
import 'package:gallery_hub_mobile_flutter/services/auth_service.dart';
import 'package:gallery_hub_mobile_flutter/services/local_storage_service.dart';
import 'package:gallery_hub_mobile_flutter/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final  _formKey = GlobalKey<FormState>();
  String email = '';
  late String password;
  String? error;
  final authService = AuthService();
  final localStorageService = LocalStorageService();
  bool isLoading = false;



  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
        ),
        child: Center(
          child: isLoading ? Center(child: CircularProgressIndicator()) :  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome to ${AppConstants.appName}", style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(
                height: 10,
              ),
              if(error != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.red,
                      Colors.red.shade400,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                    ),
                    
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child : Text(error!, style: TextStyle(color: Colors.white),),
                ),
                
              SizedBox(height: 30 ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email*'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Please insert email',
                        ),
                        validator: (email) {
                          if(email == null || email.trim().isEmpty) {
                            return 'please input email';
                          }
                          return null;
                        },
                        onSaved: (e) {
                          email = e!;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('Password*'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Please insert password',
                        ),
                        validator: (password) { 
                          if(password == null || password.trim().isEmpty) {
                            return 'please input email';
                          } else if(password.length < 8) {
                            return 'password must atleast 8 character';
                          }
                          return null;
                        },
                        onSaved: (p) {
                          password = p!;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FilledButton(onPressed: () async{
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          error = null;

                          setState(() {
                            isLoading = true;
                          });
                          // attempt to login user
                          if(await authService.loginUser(email, password)) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
                          } else {
                            error = authService.errorMessage;
                          }

                          setState(() {
                            isLoading = false;
                          });
                        }
                      }, 
                      child: Text('Login')),
                    ),
                  ],
                )
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: () {}, child: Text('Signup', textAlign: TextAlign.center,))
            ],
          ),
        ),
      ),
    );
  }
}