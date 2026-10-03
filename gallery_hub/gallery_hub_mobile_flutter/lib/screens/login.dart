
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
  bool isLoading = true;
  bool isAuth = false;

  void checkForAuth() async{
    final token = await localStorageService.getToken();

    
    

    isAuth = token != null;

    Future.delayed(Duration(seconds: 2), () {
      // check if the current widget is dispose yet
      // 1. if dispose: return; and stop execute to avoid using context
      // 2. else: continue run
      if(!mounted) return;
      
      if(isAuth) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkForAuth();
  }


  @override
  Widget build(BuildContext context) {
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
                          

                          setState(() {
                            isLoading = true;
                            error = null;
                          });

                          final success = await authService.loginUser(email, password);

                          if(!mounted) return;

                          // attempt to login user
                          if(success) {
                            Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
                          } else {
                            setState(() {
                              isLoading = false;
                              error = authService.errorMessage;
                            });
                           
                          }
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