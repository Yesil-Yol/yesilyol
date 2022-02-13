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

class CreatePostScreen extends StatefulWidget {
  final User user;
  final String category;
  const CreatePostScreen({Key key, this.user,this.category}) : super(key: key);

  @override
  CreatePostScreenState createState() => CreatePostScreenState(user: user,category:category);
}

class CreatePostScreenState extends State<CreatePostScreen> with SingleTickerProviderStateMixin {
  final User user;
  final String category;
  CreatePostScreenState({Key key, this.user,this.category});

  File image;
  bool imageselected = false;
  List<Path> pathimages;
  List<File> images = List<File>();
  File video;
  String articleid;
  bool everythingfine = false;
  final formKey = GlobalKey<FormState>();
  List<FileImage> _listOfImages = <FileImage>[];
  List<File> pickedimages;
  final TextEditingController location= TextEditingController();
  final TextEditingController caption= TextEditingController();
  final TextEditingController details= TextEditingController();
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
  final picker = ImagePicker();
  String _retrieveDataError;


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

  @override
  void deactivate() {

    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new Container(),
        backgroundColor: Colors.white,
        actions: <Widget>[

          IconButton(
            color: Colors.black,
            onPressed: () {
              isVideo = false;

              _onImageButtonPressed(
                ImageSource.gallery,
                context: context,
                isMultiImage: true,
              );
            },
            tooltip: 'Pick Multiple Image from gallery',
            icon: Icon(Icons.photo_library),
          ),


        ],
      ),
      body:SingleChildScrollView(
        child: Form(
          key: formKey,
          child:  Column(
            children: <Widget>[
              category == 'event' ? Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01 ,right: MediaQuery.of(context).size.width*0.01),
                child:
                Container(
                  margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.023 , vertical: MediaQuery.of(context).size.height*0.013),
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
                      controller: location,
                      maxLength: 50,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,

                        hintText:'Konum',hintStyle: TextStyle(fontWeight:  FontWeight.w400,color: Colors.black),
                      ),
                    ),
                  ),
                ),

              ) : Container(),

              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01 ,right: MediaQuery.of(context).size.width*0.01),
                child:
                Container(
                  margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.023 , vertical: MediaQuery.of(context).size.height*0.013),
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
                      controller: caption,
                      maxLength: 250,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,

                        hintText: 'Yazı',hintStyle: TextStyle(fontWeight:  FontWeight.w400,color: Colors.black),
                      ),
                    ),
                  ),
                ),

              ),

              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01 ,right: MediaQuery.of(context).size.width*0.01),
                child:
                Container(
                  margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.023 , vertical: MediaQuery.of(context).size.height*0.013),
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
                      controller: details,
                      maxLength: 1000,
                      minLines: 1,
                      maxLines: 200,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,

                        hintText: 'Detaylar',hintStyle: TextStyle(fontWeight:  FontWeight.w400,color: Colors.black),
                      ),
                    ),
                  ),
                ),

              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01 ,right: MediaQuery.of(context).size.width*0.01),
                child:
                Container(
                  margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.023 , vertical: MediaQuery.of(context).size.height*0.013),
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
                      controller: price,
                      keyboardType:TextInputType.number,
                      maxLength: 20,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,

                        hintText: 'Hedef Bağış',hintStyle: TextStyle(fontWeight:  FontWeight.w400,color: Colors.black),
                      ),
                    ),
                  ),
                ),

              ),
              SizedBox(height:MediaQuery.of(context).size.height*0.025),

              SizedBox(
                width: MediaQuery.of(context).size.width*0.3 , height: MediaQuery.of(context).size.height*0.06,
                child: RaisedButton(
                  child: Text('Bitti'),
                  textColor: Colors.blue,
                  color: Colors.white,
                  onPressed: () {

                    Future.delayed(new Duration(seconds:4), () {Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(user: user,),),);});
                    setState(() {

                      CreatePost(user,user.id,user.username, location.text,caption.text, _imageFileList,category,details.text,int.parse(price.text));


                    });
                  },
                ),
              ),
              SizedBox(height:MediaQuery.of(context).size.height*0.05),



            ],
          ),
        ),
      ),
    );

  }

}
