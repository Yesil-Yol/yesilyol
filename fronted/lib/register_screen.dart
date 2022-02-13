import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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

class RegisterScreen extends StatefulWidget {

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin{
  String createpersonprofiletype = 'P';
  String createpersongendertype = 'NB';
  User uniuser;
  bool approved = false;
  bool errortrue = false;
  File image;
  int signupcheck = 0;
  int signupcheck2 = 0;
  bool obscurepassword = true;
  final _formKey = GlobalKey<FormState>();
  final navigatorKey2 = GlobalKey<NavigatorState>();
  final TextEditingController _email= TextEditingController();
  final TextEditingController _password= TextEditingController();
  final TextEditingController _username= TextEditingController();
  final TextEditingController _firstname= TextEditingController();
  final TextEditingController _lastname= TextEditingController();
  final TextEditingController _location= TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController tags = TextEditingController();
  final picker = ImagePicker();


  bool imageselected = false;
  List<Path> pathimages;
  List<File> images = [];
  File video;
  String articleid;
  bool everythingfine = false;
  final formKey = GlobalKey<FormState>();
  bool allowcalls = false;
  bool allowmessaging = false;
  bool disablecomments = false;
  bool disablestats = false;
  bool checkasnsfw = false;
  bool checkassensitive = false;
  bool checkasspoiler = false;
  int postcheck = 0;
  List<FileImage> _listOfImages = <FileImage>[];
  String createpostgroupid;
  bool ispromovideo = false;
  bool waiting = true;
  bool done = false;
  bool businessatt = false;
  bool isjobposting = false;
  bool isnstl = false;
  bool isnsfw = false;
  bool issensitive = false;
  bool isspoiler = false;
  List<File> pickedimages;
  final TextEditingController location= TextEditingController();
  final TextEditingController caption= TextEditingController();
  final TextEditingController details= TextEditingController();
  final TextEditingController details2= TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController name= TextEditingController();
  final TextEditingController price= TextEditingController();
  List<String> tagsfinal = [''];
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  List<PickedFile> _imageFileList;
  bool isVideo = false;
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  bool searching = false;
  bool searching2 = false;
  bool firsttime11 = false;
  String _retrieveDataError;
  set _imageFile(PickedFile value) {
    _imageFileList = value == null ? null : [value];
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Image carouselimages(PickedFile image){
    return Image.file(File(image.path));
  }

  Widget _previewImages() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    else if (_pickImageError != null) {
      return Text(
        'Image not picked: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        'You have not yet picked an image',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {


    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }


  void _onImageButtonPressed(ImageSource source, {BuildContext context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final pickedFileList = await _picker.getMultiImage(

          imageQuality: 60,
        );
        setState(() {
          _imageFileList = pickedFileList;
          for(int i=0;i<_imageFileList.length;i++){
            pickedimages.add(File(_imageFileList[i].path));
          }
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Userdata(String email,String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
  }


  pickFromCamera() async {
    final _image = await picker.getImage(source: ImageSource.camera,  imageQuality: 80);

    setState(() {
      image = File(_image.path);
    });
  }

  pickFromPhone() async {
    final _image = await picker.getImage(source: ImageSource.gallery,  imageQuality: 80);

    setState(() {
      image = File(_image.path);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SingleChildScrollView(

        child: Container(
          height: MediaQuery.of(context).size.height*1.2,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),

                ],),

              SizedBox(height: MediaQuery.of(context).size.height*0.04),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Profil Resmi Ekle:'),
                        IconButton(
                          icon: Icon(Icons.add_photo_alternate,color:Colors.black),
                          onPressed: () {
                            isVideo = false;

                            _onImageButtonPressed(
                                ImageSource.gallery,
                                context: context,
                                isMultiImage: true
                            );
                          },
                        )

                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.03,),

                    CupertinoFormSection(
                        header: Text('Gerekli'),
                        children: [
                          CupertinoFormRow(
                              child: CupertinoTextFormFieldRow(
                                placeholder: 'Posta',
                                controller: _email,
                                maxLength: 50,
                              ),
                              prefix: Text("Posta*")
                          ),
                          CupertinoFormRow(
                              child: CupertinoTextFormFieldRow(
                                placeholder: 'Şifre',
                                controller: _password,
                                maxLength: 30,
                              ),
                              prefix: Text("Şifre*")
                          ),
                          CupertinoFormRow(

                            child: CupertinoTextFormFieldRow(
                              placeholder: 'Kullanıcı Adı',
                              controller: _username,
                              maxLength: 20,
                            ),

                            prefix: Text('Kullanıcı Adı'),
                          )
                        ]),
                    CupertinoFormSection(
                        header: Text('Kişisel Bilgiler'),
                        children: [
                          CupertinoFormRow(
                              child: CupertinoTextFormFieldRow(
                                placeholder: 'İsim Soyisim',
                                controller: _firstname,
                                maxLength: 50,
                              ),
                              prefix: Text('İsim Soyisim')
                          ),

                          CupertinoFormRow(

                            child: CupertinoTextFormFieldRow(
                              placeholder: 'Telefon Numarası',
                              controller: _phonenumber,
                              maxLength: 30,
                            ),

                            prefix: Text('Telefon Numarası'),
                          )
                        ]),
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.07),


                    SizedBox(

                      width:MediaQuery.of(context).size.width*0.36, height:MediaQuery.of(context).size.height*0.07,
                      child: RaisedButton(

                        child: Text('Bitti'
                          ,style:TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.025,
                          ),
                        ),
                        textColor: Colors.blue,
                        color: Colors.white,
                        onPressed: () {
                          print('şş');
                          setState(() {
                            CreateUserPP(String userid,File image) async {

                              String imagename;
                              imagename = image == null ? 'empty' : ( imagename = image.path.split('/').last);
                              try {

                                if(imagename == 'empty'){

                                }
                                else if(imagename !=  'empty')
                                {
                                  FormData formData2 = new FormData.fromMap({
                                    'image' : await MultipartFile.fromFile(image.path, filename:imagename),
                                  });
                                  Response response2 = await Dio().patch("$SERVER_IP/api/users/$userid/", data: formData2);
                                  if(response2.statusCode == 201){ print('Image Created');
                                  }
                                }


                              } catch (e) {
                                print(e);
                              }

                            }
                            Future<User> CreateUser(String email,String password,String username,String firstname,
                                String location,String phone,String about,File image) async {
                              print('aa');
                              final http.Response response = await http.post(
                                Uri.parse("$SERVER_IP/api/users/"),

                                headers: <String, String>{
                                  'Allow':'Post',
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
                                },
                                body: jsonEncode(<String, dynamic>{
                                  'email' : email,
                                  'username' : username,
                                  'password' : password,
                                  'fullname' : firstname,
                                  'phone_number' : phone,
                                  'bio' : '-',
                                  'location' : '-',
                                  'image' : null,
                                }),
                              );

                              if (response.statusCode == 201) {
                                print(response.body);
                                _showSuccess();
                                var responseJson = json.decode(response.body);
                                String responseinit = responseJson.toString();
                                print(responseinit);
                                uniuser = User.fromJSON(responseJson);
                                CreateUserPP(uniuser.id,File(_imageFileList.first.path));
                                Future.delayed(new Duration(seconds:2), () {   navigatelogin(uniuser);});
                              }

                              else {
                                print(response.body);
                                errortrue = true;
                              }
                            }

                            Userdata(_email.text,_password.text);
                            _email.text == '' ? _showError('geçersiz posta') : signupcheck = signupcheck + 1;
                            _password.text == '' ? _showError('geçersiz şifre') : signupcheck = signupcheck + 1;
                            _username.text == '' ? _showError('geçersiz kullanıcı adı') : signupcheck = signupcheck + 1;
                            signupcheck2 = signupcheck ;
                            signupcheck = 0;
                            print(signupcheck2);
                            signupcheck2 == 3 ? CreateUser(_email.text,_password.text,_username.text,_firstname.text,_location.text,_phonenumber.text
                                ,_bio.text,image) : _showError('giriş hatası');
                            signupcheck = 0;
                            if (errortrue == true){
                              errortrue = false;
                              _showError('hata var');
                            }



                          });

                        },

                      ),
                    ),

                  ],
                ),
              ),


            ],
          ),

        ),

      ),

    );

  }
  navigatelogin(User loginuser){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(user: loginuser)));
  }
  _showSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Giriş yapılıyor!'),
      backgroundColor: Colors.green,
    ));
  }
  _showError(String error) {
    _scaffoldKey.currentState.showSnackBar(  SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}