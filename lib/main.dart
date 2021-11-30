import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:parkinglot/APIResponse.dart';
import 'package:parkinglot/Methods/authenticate.dart';
import 'package:parkinglot/Methods/park.dart';
import 'package:parkinglot/home.dart';
import 'globals.dart' as globals;



void main() {
  HttpOverrides.global = new MyHttpOverrides(); //Override SSl Certificate
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to ParkingLot App'),
        ),
        resizeToAvoidBottomInset: false,
        body: LoginForm()
      ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
      )
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _username = "";
  String? _password = "";
  bool _isObscure = true;

  //Validator
  final formKey = GlobalKey < FormState > ();

  Authenticate authenticate = Authenticate();
  GetPark park = GetPark();
  var _response;
  var listPark;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
    Form(
      key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                  child: Text('User Login', style: TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,fontSize: 25))
              ),
            ),
            //USERNAME
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextFormField(
                initialValue: null,
                controller: _usernameController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please provide a username';
                  }
                },
                onSaved: (String? value) {
                  _username = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            //PASSWORD
            Padding(
                padding:EdgeInsets.fromLTRB(50, 30, 50, 0),
                child: TextFormField(
                  obscureText: _isObscure,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please provide a password';
                    }
                  },
                  controller: _passwordController,
                  onSaved: (String? value){
                    _password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                )
            ),
            Padding(padding: EdgeInsets.fromLTRB(50, 60, 50, 0),
              child: ElevatedButton(
                onPressed: () {
                  _performLogin();
                },
                child: Text('Login', style: TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,fontSize: 20)),
                style: ElevatedButton.styleFrom(fixedSize: Size(150, 50)),
              ),
            ),
          ],
        ),
      ),
    );

  }
  void _performLogin() async{
    formKey.currentState!.save();
    if(formKey.currentState!.validate()){
      _response = await authenticate.login(_username, _password);

      print((_response.Response as Response).message);

      if(((_response.Response as Response).message != 'Unassigned')){
        //SaveToken
        globals.storage.write(key: "Jwt", value: (_response.Response as Response).message/*token*/);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );

      }else{
        int? errorCode = (_response.Error as Error).status;
        String? message = (_response.Error as Error).title;

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Username or Password incorrect. $errorCode - $message')
            )
        );
      }
    }
  }
}


