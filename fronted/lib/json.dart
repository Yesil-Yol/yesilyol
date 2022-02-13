import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dio_http/dio_http.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'main.dart';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

CreateComment(String author,String article,String content) async {
  try {
    FormData formData = new FormData.fromMap({
      'author' : author,
      'article' : article,
      'content' : content,
    });

    await Dio().post("$SERVER_IP/api/comments/", data: formData);

  } catch (e) {
    print(e);
  }
}

Future<User> FetchUser(String userid) async {
  final response = await http.get( Uri.parse("$SERVER_IP/api/users/$userid/?format=json"));
  var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
  return User.fromJSON(responseJson);
}

Future<Widget> SignInUser(String email, String password,bool check) async {
  User _user;

  if(check == false){
    return LoginScreen();
  }

  WidgetsFlutterBinding.ensureInitialized();
  final http.Response response = await http.post( Uri.parse("$SERVER_IP/rest-auth/login/"), body: jsonEncode(<String, String>{
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
    return HomeScreen(user:_user);
  }
  else{
    return LoginScreen();
  }


}

Future<List<Comment>> FetchComments(http.Client client,String postid) async {
  List<Comment> commentsfinal = [];
  final response = await http.get( Uri.parse("$SERVER_IP/api/comments/?format=json"));
  final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  List<Comment> comments1 = parsed.map<Comment>((json) => Comment.fromJSON(json)).toList();
  for(int index = 0; index < comments1.length; index++) {
    if (comments1[index].article == postid) {commentsfinal.add(comments1[index]);}
  }
  return commentsfinal;
}

Future<List<RecycleBin>> FetchRecycleBins(http.Client client,User user) async {
  final response = await http.get( Uri.parse("$SERVER_IP/api/recyclebins/?format=json"));
  final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  return parsed.map<RecycleBin>((json) => RecycleBin.fromJSON(json)).toList();

}

Future<List<Post>> FetchPosts(http.Client client,User user) async {
  final response = await http.get( Uri.parse("$SERVER_IP/api/articles/?format=json"));
  final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJSON(json)).toList();

}

CreateRecycleBinRequest(String userid,File image,double lat,double lng) async {
  String imagename = '${userid}_${image.path.split('/').last}';
  try {
    FormData formData = new FormData.fromMap({
      'author' : userid.toString(),
      'image' : null,
      'locationlat' : lat.toString(),
      'locationlng' : lng.toString(),
      'image' : await MultipartFile.fromFile(image.path, filename:imagename),
      'is_activated' : false,
    });

    Response response = await Dio().post("$SERVER_IP/api/recyclebins/", data: formData);
    String responseinit = response.toString();
    print(responseinit);




  } catch (e) {
    print(e);
  }
}


CreatePost(User mainuser,String author,String username,String location,String caption,List<PickedFile> images,String category
    ,String details,int targetfund) async {
  caption = caption == '' ? '-' : caption;

  try {
    FormData formData = new FormData.fromMap({
      'author' : author.toString(),
      'location' : location,
      'caption' : caption,
      'details' : details,
      'category' : category,
      'targetfund' : targetfund,
      'currentfund' : 0,
    });



    Response response = await Dio().post("$SERVER_IP/api/articlecreate/", data: formData);
    String responseinit = response.toString();
    String articleid = responseinit.substring(7,43);


    for (int i = 0; i < images.length; i++)
    {


      CreatePostImage(username,articleid,File(images[i].path),mainuser);}



  } catch (e) {
    print(e);
  }
}

CreatePostImage(String author,String article,File image,User user) async {
  String imagename = '${author}_${image.path.split('/').last}';

  try {
    FormData formData = new FormData.fromMap({
      'article' : article,
      'image' : await MultipartFile.fromFile(image.path, filename:imagename),
    });

    Response response = await Dio().post("$SERVER_IP/api/articleimages/", data: formData);

    if(response.statusCode == 201){

    }
    else{
      print(response.statusCode);
      print(response.data.toString());
    }

  } catch (e) {
    print(e);
  }

}

EditPost(Post post1,int paid) async {

  try {


    FormData formData = new FormData.fromMap({
      'author' : post1.authorstring.toString(),
      'location' : post1.location,
      'caption' : post1.caption,
      'details' : post1.details,
      'category' : post1.category,
      'targetfund' : post1.targetfund,
      'currentfund' : post1.currentfund+paid,
    });



    Response response = await Dio().patch("$SERVER_IP/api/articles/${post1.id}/", data: formData);
    print(response.toString());
  } catch (e) {
    print(e);
  }
}

Future<User> LikeUser(String user1,String user2) async {
  final http.Response response = await http.post(
    Uri.parse("$SERVER_IP/api/userlikes/"),

    headers: <String, String>{
      'Allow':'Post',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
    },
    body: jsonEncode(<String, dynamic>{
      'author': user1,
      'profile': user2,
    }),
  );

  if (response.statusCode == 201) {
    print('User liked successfully');
  }

  else {
    throw new Exception(response.body);
  }
}

Future<Comment> DeleteComment(String id) async {
  final http.Response response = await http.delete(
    Uri.parse("$SERVER_IP/api/comments/$id/"),

    headers: <String, String>{
      'Allow':'Delete',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
    },

  );

  if (response.statusCode == 204) {
    print('Comment deleted successfully');
  }

  else {
    throw new Exception(response.body);
  }
}

Future<User> LikePost(String user1,String article) async {
  final http.Response response = await http.post(
    Uri.parse("$SERVER_IP/api/postlikes/"),

    headers: <String, String>{
      'Allow':'Post',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
    },
    body: jsonEncode(<String, dynamic>{
      'author': user1,
      'article': article,
    }),
  );

  if (response.statusCode == 201) {
    print('Post liked successfully');
  }

  else {
    throw new Exception(response.body);
  }
}

Future<Post> DeletePost(String id) async {
  final http.Response response = await http.delete(
    Uri.parse("$SERVER_IP/api/articles/$id/"),

    headers: <String, String>{
      'Allow':'Delete',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
    },

  );

  if (response.statusCode == 204) {
    print('Post deleted successfully');
  }

  else {
    throw new Exception(response.body);
  }
}

Future<User> UnlikePost(String id) async {
  final http.Response response = await http.delete(
    Uri.parse("$SERVER_IP/api/postlikes/$id/"),

    headers: <String, String>{
      'Allow':'Delete',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
    },

  );

  if (response.statusCode == 204) {
    print('Post unliked successfully');
  }

  else {
    throw new Exception(response.body);
  }
}