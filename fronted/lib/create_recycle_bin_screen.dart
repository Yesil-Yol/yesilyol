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

class CreateRecycleBinScreen extends StatefulWidget {
  final User user;
  final double lat;
  final double lng;
  const CreateRecycleBinScreen({Key key, this.user,this.lat,this.lng}) : super(key: key);

  @override
  CreateRecycleBinScreenState createState() => CreateRecycleBinScreenState(user: user,lat:lat,lng:lng);
}

class CreateRecycleBinScreenState extends State<CreateRecycleBinScreen> with SingleTickerProviderStateMixin {
  final User user;
  final double lat;
  final double lng;
  CreateRecycleBinScreenState({Key key, this.user,this.lat,this.lng});

  File image;
  bool imageselected = false;
  List<Path> pathimages;
  List<File> images = List<File>();
  final formKey = GlobalKey<FormState>();
  List<FileImage> _listOfImages = <FileImage>[];
  List<File> pickedimages;

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

      body:SingleChildScrollView(
        child: Form(
          key: formKey,
          child:  Column(
            children: <Widget>[
              SizedBox(height:100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Resim Ekle:'),
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
                      CreateRecycleBinRequest(user.id, File(_imageFileList.first.path),lat,lng);
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