import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:greenmap/profile_screen.dart';
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
import 'crowdfunding_screen.dart';
import 'events_screen.dart';
import 'json.dart';
import 'map_screen.dart';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';


class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(user: user,key: key);
}

class _HomeScreenState extends State<HomeScreen> {
  final User user;
  _HomeScreenState({Key key, this.user,});

  @override
  Future<User> callUser(String userid) async {
    Future<User> _user = FetchUser(userid);
    return _user;
  }

  int _currentTab =  0 ;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<User>(
        future: callUser(user.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData ? Scaffold(
              body: PageView(
                controller: _pageController,
                children: <Widget>[
                  FeedScreen(user: snapshot.data,),
                  Feed2Screen(user: snapshot.data,),
                  FeedScreenMap(user:snapshot.data),
                  ProfileScreen(user:snapshot.data),
                ],
                onPageChanged: (int index) {
                  setState(() {
                    _currentTab = index;
                  });
                },
              ),
              bottomNavigationBar: CupertinoTabBar(

                currentIndex: _currentTab,
                onTap: (int index) {
                  setState(() {
                    _currentTab = index;
                  });
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
                items: [

                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.calendar_today,
                      size: MediaQuery.of(context).size.height*0.045,
                      color:   Colors.black,
                    ),
                  ),     BottomNavigationBarItem(
                    icon: Icon(
                      Icons.attach_money,
                      size: MediaQuery.of(context).size.height*0.045,
                      color: Colors.black,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.map,
                      size: MediaQuery.of(context).size.height*0.045,
                      color: Colors.black,
                    ),
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                      size: MediaQuery.of(context).size.height*0.045,
                      color: Colors.black,
                    ),
                  ),
                ],
              )) :  Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));
        });
  }
}