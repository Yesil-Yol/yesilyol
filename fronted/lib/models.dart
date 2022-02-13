import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:dio_http/dio_http.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'json.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

enum LocationAccuracy {
  powerSave, // To request best accuracy possible with zero additional power consumption,
  low, // To request "city" level accuracy
  balanced, // To request "block" level accuracy
  high, // To request the most accurate locations available
  navigation // To request location for navigation usage (affect only iOS)
}

enum PermissionStatus {
  /// The permission to use location services has been granted.
  granted,
  // The permission to use location services has been denied by the user. May have been denied forever on iOS.
  denied,
  // The permission to use location services has been denied forever by the user. No dialog will be displayed on permission request.
  deniedForever
}

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    print('unsuccessful');
    return null;
  }
}

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({
    @required this.bounds,
    @required this.polylinePoints,
    @required this.totalDistance,
    @required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) return null;

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
      PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}

class User {

  final String id;
  final String email;
  final String username;
  final String fullname;
  final String image;
  final String phone_number;
  final String location;
  List<LikeUserModel> karma= [] ;
  List<LikeUserModel> envkarma= [] ;
  User({this.id,this.email, this.username, this.fullname, this.image, this.phone_number,  this.location,this.karma,this.envkarma});


  factory User.fromJSON(Map<String, dynamic> jsonMap) {


    return User(
      id: jsonMap['id'] as String,
      email: jsonMap['email'] as String,
      username: jsonMap['username'] as String,
      fullname: jsonMap['fullname'] as String,
      image: jsonMap['image'] as String,
      phone_number: jsonMap['phone_number'] as String,
      location: jsonMap['location'] as String,
      karma: jsonMap["userlikes_set"] != null ? List<LikeUserModel>.from( jsonMap["userlikes_set"].map((x) => LikeUserModel.fromJSON(x))) : [],

      envkarma: jsonMap["usersecondlikes_set"] != null ? List<LikeUserModel>.from( jsonMap["usersecondlikes_set"].map((x) => LikeUserModel.fromJSON(x))) : [],
    );
  }

  bool islikedprofile(User visiteduser,User user,bool liked2,bool unliked) {
    bool isliked = false;
    if (liked2 == true) {return true;}
    if (unliked == true) {return false;}
    for(int index = 0; index < user.karma.length; index++)
    {
      isliked = user.karma[index].profile == visiteduser.id ? true : false ;
      if (isliked == true) {
        return true;
      }
    }


    return isliked;
  }

  String userlikeid(User user,String visiteduserid){
    String likeid;

    for(int index = 0; index <user.karma.length; index++) {
      likeid =  visiteduserid == user.karma[index].profile ? user.karma[index].id : '';

      if(likeid.isNotEmpty){
        return likeid;
      }
    }

    return likeid;
  }

  bool issecondlikedprofile(User visiteduser,User user,bool liked2,bool unliked) {
    bool isliked = false;
    if (liked2 == true) {return true;}
    if (unliked == true) {return false;}
    for(int index = 0; index < user.envkarma.length; index++)
    {
      isliked = user.envkarma[index].profile == visiteduser.id ? true : false ;
      if (isliked == true) {
        return true;
      }
    }


    return isliked;
  }

  String usersecondlikeid(User user,String visiteduserid){
    String likeid;

    for(int index = 0; index <user.envkarma.length; index++) {
      likeid =  visiteduserid == user.envkarma[index].profile ? user.envkarma[index].id : '';

      if(likeid.isNotEmpty){
        return likeid;
      }
    }

    return likeid;
  }

}

class RecycleBin {
  final String id;
  final String image;
  final String author;
  final String locationlng;
  final String locationlat;
  final bool isactivated;
  RecycleBin({this.id,this.isactivated,this.author,this.locationlng,this.locationlat,this.image});

  factory  RecycleBin.fromJSON(Map<String, dynamic> jsonMap) {
    return  RecycleBin(
      id: jsonMap['id'] as String,
      author: jsonMap['author'] as String,
      locationlat: jsonMap['locationlat'] as String,
      locationlng: jsonMap['locationlng'] as String,
      isactivated: jsonMap['is_activated'] as bool,
      image:  jsonMap['image'] as String,
    );
  }
}

class LikeUserModel {
  final String id;
  final String profile;
  final String author;
  LikeUserModel({this.id,this.author,this.profile});

  factory  LikeUserModel.fromJSON(Map<String, dynamic> jsonMap) {
    return  LikeUserModel(
      id: jsonMap['id'] as String,
      author: jsonMap['author'] as String,
      profile:  jsonMap['profile'] as String,
    );
  }
}

class Feed{
  int count;
  String next;
  String previous;
  List<Post> posts;
  Feed({this.count,this.next,this.previous,this.posts});

  factory Feed.fromJson(Map<String, dynamic> json,categorycon) {
    if (json["results"] != null) {
      var results= json["results"] as List;
      List<Post> posts= results.map((list) => Post.fromJSON(list)).toList();
      return Feed(
          posts: posts,
          count: json["count"] as int,
          previous: json["previous"] as String,
          next: json["next"] as String
      );
    }
    return null;
  }
}

class ArticleImage {
  final String id;
  final String article;
  final String image;


  ArticleImage({this.id,this.article,this.image});


  factory  ArticleImage.fromJSON(Map<String, dynamic> jsonMap) {
    return  ArticleImage(
      id: jsonMap['id'] as String,
      article: jsonMap['article'] as String,
      image: jsonMap['image'] as String,
    );
  }
  Image carouselimages(){
    if(image.isNotEmpty){
      return Image.network(image,fit: BoxFit.cover,);
    }
    else if (image == null){
      return Image.network('https://t4.ftcdn.net/jpg/02/07/87/79/360_F_207877921_BtG6ZKAVvtLyc5GWpBNEIlIxsffTtWkv.jpg',fit: BoxFit.cover,);
    }
  }
}

class ArticleLike {
  final String id;
  final String article;
  final String authorstring;


  ArticleLike({this.id,this.article,this.authorstring});


  factory  ArticleLike.fromJSON(Map<String, dynamic> jsonMap) {
    return  ArticleLike(
      id: jsonMap['id'] as String,
      article: jsonMap['article'] as String,
      authorstring: jsonMap['author'] as String,
    );
  }
}

class Post {
  final String id;
  final String authorstring;
  final String caption;
  final String category;
  final String timestamp;
  final String details;
  final int targetfund;
  final int currentfund;
  final String location;
  List<ArticleLike> likes = [];
  List<Comment> comments= [];
  List<ArticleImage> images = [];
  bool liked = false;
  bool liked2 = false;
  bool unliked = true;
  bool bookmarked = false;
  bool isauthor = false;

  Post({this.id,this.targetfund,this.currentfund,this.authorstring,this.caption,this.timestamp, this.details,
    this.images,this.liked,this.comments, this.likes,  this.location,this.category});

  factory Post.fromJSON(Map<String, dynamic> jsonMapPost) {

    return Post(
      id: jsonMapPost['id'] as String,
      caption: jsonMapPost['caption'] as String,
      authorstring: jsonMapPost['author'] as String,
      timestamp: jsonMapPost['timestamp'] as String,
      details: jsonMapPost['details'] as String,
      targetfund: jsonMapPost['targetfund'] as int,
      currentfund: jsonMapPost['currentfund'] as int,
      location: jsonMapPost['location'] as String,
      category: jsonMapPost['category'] as String,
      likes:  jsonMapPost["postlikes_set"] != null ? List<ArticleLike>.from( jsonMapPost["postlikes_set"].map((x) => ArticleLike.fromJSON(x))) : [],
      comments: jsonMapPost["comments_set"] != null ? List<Comment>.from( jsonMapPost["comments_set"].map((x) => Comment.fromJSON(x))) : [],
      images: jsonMapPost["images_set"] != null ? List<ArticleImage>.from( jsonMapPost["images_set"].map((x) => ArticleImage.fromJSON(x))) : [],
    );}

  DateTime formatDate() {
    final formatter = DateFormat("yyyy-MM-ddThh:mm:ss");
    final dateTimeFromStr = formatter.parse(timestamp);
    return dateTimeFromStr;
  }


  String postlikeid(Post post,String userid){
    String likeid;
    for(int index = 0; index <post.likes.length; index++) {
      likeid =  userid == post.likes[index].authorstring ? post.likes[index].id : '';
      print(likeid);
      if(likeid.isNotEmpty){
        return likeid;}}
    return likeid;
  }

  void postunlikeprocess(String userid,Post post1) {
    String likeid;
    likeid = post1.postlikeid(post1,userid);
    print(likeid);
    UnlikePost(likeid);
    likeid = '';
    post1.liked2 = false;
    post1.liked = false;
    post1.unliked = true;
  }

  bool postliked(String userid,bool liked,bool unliked) {
    bool like1;
    if (liked == true){return true;}
    if (liked2 == true){return true;}
    if (unliked == true){return false;}

    for(int index = 0; index <likes.length; index++) {
      like1 =  userid == likes[index].authorstring ? true : false;
      if(like1 == true){
        return true;}
    }
    return like1;
  }



  bool isauthorfunc(String userid,String authorid,) {
    return userid == authorid ? true : false;
  }




}

class Comment {
  final String id;
  final String authorstring;
  final String article;
  final String parent;
  final String content;
  final String timestamp;

  Comment({this.id,this.authorstring,this.article,this.parent,this.content,this.timestamp});
  factory  Comment.fromJSON(Map<String, dynamic> jsonMap) {
    return  Comment(
      id: jsonMap['id'] as String,
      authorstring: jsonMap['author'] as String,
      article: jsonMap['article'] as String,
      parent: jsonMap['parent'] as String,
      content: jsonMap['content'] as String,
      timestamp: jsonMap['timestamp'] as String,
    );
  }



  DateTime formatDate() {
    final formatter = DateFormat("yyyy-MM-ddThh:mm:ss");
    final dateTimeFromStr = formatter.parse(timestamp);
    return dateTimeFromStr;
  }
}

