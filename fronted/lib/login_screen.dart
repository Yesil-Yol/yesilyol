import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:greenmap/register_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio_http/dio_http.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:pay/pay.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:ui';
import 'package:tcard/tcard.dart';
import 'home_screen.dart';
import 'json.dart';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  UserData(String email,String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
  }


  int check = 0;
  int falsecheck = 0;


  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool loginattempt = false;
  bool loginsuccessful = false;
  bool lol = false;
  int signincheck = 0;
  Future<User> signinFunc;
  String error;
  User _user;
  bool obscurepassword = true;

  @override
  Widget build(BuildContext context) {

    return loginattempt == true?
    Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:  CircularProgressIndicator(backgroundColor: Colors.pink,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)),
          )

        ],
      ),
    ) : Container(
      alignment: Alignment.center,
      child: Scaffold(
        body: SingleChildScrollView(




          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                    Text('Hoşgeldiniz',
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,

                      ),),
                  ],),

                SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
                Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child:
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical:4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child:  Padding(
                            padding: EdgeInsets.only(left : 8),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,

                                labelText: 'Email',
                                hintText: 'Email',
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical:4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child:  Padding(
                            padding: EdgeInsets.only(left : 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIcon:     IconButton(
                                    icon: Icon(Icons.visibility),
                                    iconSize: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.03,
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        obscurepassword == true ? obscurepassword = false : obscurepassword = true;
                                      });
                                    }
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,

                                labelText: 'Şifre',
                                hintText:  'Şifre',
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                              obscureText: obscurepassword,
                              controller: _passwordController,
                            ),
                          ),
                        ),

                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                      SizedBox(

                        width:  MediaQuery.of(context).size.width*0.4, height:MediaQuery.of(context).size.height*0.06,
                        child: RaisedButton(
                          child: Text('Giriş Yap', style:TextStyle(fontSize:MediaQuery.of(context).size.height*0.025,),),
                          textColor: Colors.blue,
                          color: Colors.white,
                          onPressed:  (){
                            setState(() {
                              UserData(_emailController.text,_passwordController.text);
                              Future<User> signIn(String email, String password) async {

                                WidgetsFlutterBinding.ensureInitialized();
                                final http.Response response = await http.post( Uri.parse("$SERVER_IP/rest-auth/login/"),
                                  body: jsonEncode(<String, String>{
                                    'email':email,
                                    'password':password,
                                  }),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                    HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
                                  },
                                );
                                if (response.statusCode == 200) {
                                  var responseJson = json.decode(response.body);
                                  _user = User.fromJSON(responseJson['user']);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(user: _user)));
                                }
                                else {
                                  error = response.body;
                                  setState(() {loginattempt = false;});
                                  _showError(error);
                                }

                              };
                              signIn(_emailController.text,_passwordController.text);

                            });
                          },
                        ),
                      ),

                      SizedBox(height:MediaQuery.of(context).size.height*0.03),

                      SizedBox(

                        width:MediaQuery.of(context).size.width*0.4 ,height:MediaQuery.of(context).size.height*0.06,
                        child: RaisedButton(
                          child: Text('Kaydol',
                            style:TextStyle(
                              fontSize:MediaQuery.of(context).size.height*0.025,
                            ),),
                          textColor: Colors.blue,
                          color: Colors.white,
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterScreen(

                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height*0.1),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showError(String error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}