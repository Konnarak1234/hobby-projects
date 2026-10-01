
import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/services/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final  _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  final loginService = LoginService();

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome Gallery Hub', style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: 40 ),
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
                          
                          // attempt to login user
                          loginService.loginUser(email, password);
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