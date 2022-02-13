import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';


class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key key, this.user,}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState(user: user,);
}

class ProfileScreenState extends State<ProfileScreen> {
  final User user;
  ProfileScreenState({Key key, this.user,});





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            children: <Widget>[

              user.image == null ? Container() : Column(

                children: <Widget>[
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.5,


                      child: Image.network(user.image == null ? 'https://st2.depositphotos.com/4111759/12123/v/600/depositphotos_121233262-stock-illustration-male-default-placeholder-avatar-profile.jpg' : user.image,
                        fit:BoxFit.cover,
                      )
                  ),

                ],

              ),

              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kullanıcı Adı: @${user.username}",
                    style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * 0.023,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ad Soyad: ${user.fullname}",
                    style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * 0.023,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),    SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Telefon numarası: ${user.phone_number}",
                    style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * 0.023,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03,),


              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.018,),
              Container(
                height:  MediaQuery
                    .of(context)
                    .size
                    .height * 0.06,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child:   InkWell(
                          child: ListTile(
                            title: Text(
                              user.karma.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Karma'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.018,)),
                          ),
                          onTap: () {}),

                    ),

                  ],
                )
                ,
              ),


              SizedBox(height:200),
            ],
          ),
        ],
      ),


    );
  }
}