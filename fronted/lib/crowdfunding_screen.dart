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
import 'comments_screen.dart';
import 'create_post_screen.dart';
import 'home_screen.dart';
import 'json.dart';
import 'models.dart';
import 'pay_screen.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

class Feed2Screen extends StatefulWidget {
  final User user;
  final String postcategoryfeed;
  const Feed2Screen({Key key, this.user,this.postcategoryfeed}) : super(key: key);

  @override
  Feed2ScreenState createState() => Feed2ScreenState(user: user,postcategoryfeed: postcategoryfeed);
}

class Feed2ScreenState extends State<Feed2Screen> {
  final User user;
  final String postcategoryfeed;
  Feed2ScreenState({Key key, this.posts,this.user,this.postcategoryfeed});
  final List<Post> posts;
  Future<List<Post>> fetchPostsfuture;




  Future<void> refreshlist(){
    Navigator.push(
      context ,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          user: user,

        ),
      ),
    );
  }
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<User> refreshProfile2() async{
    return refreshProfile();
  }

  Future<User> refreshProfile() async {
    User _user1;
    WidgetsFlutterBinding.ensureInitialized();
    final http.Response response = await http.get( Uri.parse("$SERVER_IP/api/users/${user.id}/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
      },
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      _user1 = User.fromJSON(responseJson);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(user: _user1)));
    }
  }





  void initState() {
    fetchPostsfuture = FetchPosts(http.Client(),user);
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        actions: [

          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add ,color: Colors.black,size: MediaQuery.of(context).size.width*0.065),
                onPressed: () {
                  Navigator.push(
                    context ,
                    MaterialPageRoute(
                      builder: (_) => CreatePostScreen(user:user,category: 'crowdfund',
                      ),
                    ),
                  );
                },
              ),

            ],
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshlist,
        child: FutureBuilder<List<Post>>(
          future: fetchPostsfuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData ? Posts2Screen(posts: snapshot.data,user:user)
                :
            Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));

          },
        ),
      ),
    );
  }


}

class Posts2Screen extends StatefulWidget {
  final List<Post> posts;
  final User user;

  const Posts2Screen({Key key, this.user,this.posts,}) : super(key: key);

  @override
  Posts2ScreenState createState() => Posts2ScreenState(user: user,posts:posts);
}

class Posts2ScreenState extends State<Posts2Screen> {
  final List<Post> posts;
  final User user;
  Future fetchusersfuture;
  Posts2ScreenState({Key key, this.posts, this.user});
  @override
  Future<User> callUser(String userid) async {
    Future<User> _user = FetchUser(userid);
    return _user;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return  posts[index].category == 'crowdfund' ? FutureBuilder<User>(
            future: callUser(posts[index].authorstring),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData ? AspectRatio(
                aspectRatio:

                MediaQuery.of(context).size.width * 2.8 / MediaQuery.of(context).size.height * 0.23,
                child:   Padding(

                  //MediaQuery.of(context).size.width*3/MediaQuery.of(context).size.height*5.3

                  padding: EdgeInsets.all(0),
                  child: Container(

                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white   ,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child:


                    Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.symmetric(),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.009),
                              ListTile(
                                leading: CircleAvatar(
                                  radius: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.035,
                                  backgroundImage: NetworkImage(snapshot.data.image == null ? 'https://st2.depositphotos.com/4111759/12123/v/600/depositphotos_121233262-stock-illustration-male-default-placeholder-avatar-profile.jpg' : snapshot.data.image),

                                ),
                                title:  Text(
                                  snapshot.data.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.035,
                                  ),
                                ),
                                trailing: Text('Karma:${snapshot.data.karma.length}'),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02),
                              Text('${posts[index].caption == '-' ? '': posts[index].caption}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.028,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.028),
                              Text('Bağış : ${posts[index].currentfund} / ${posts[index].targetfund} TL',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.028,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.022),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02),

                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  children: <Widget>[
                                    posts[index].postliked(user.id,posts[index].liked,posts[index].unliked) == true ?  IconButton(
                                      icon: Icon(Icons.arrow_upward_outlined),
                                      iconSize: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.0425,
                                      color: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          posts[index].postunlikeprocess(user.id,posts[index]);
                                          posts[index].postliked(user.id,posts[index].liked,posts[index].unliked);
                                        });
                                      },
                                    ): IconButton(
                                        icon: Icon(Icons.arrow_upward),
                                        iconSize: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.0425,
                                        color: Colors.black,
                                        onPressed: () {
                                          setState(() {
                                            posts[index].liked = true;
                                            posts[index].unliked = false;
                                            posts[index].postliked(user.id,posts[index].liked,posts[index].unliked);
                                          });

                                          LikePost(user.id, posts[index].id);
                                          LikeUser(user.id,snapshot.data.id);
                                        }
                                    ),
                                    InkWell(
                                        child:  Text(posts[index].liked == true ? "${posts[index].likes.length+1}" : "${posts[index].likes.length}",
                                          textAlign: TextAlign.center,

                                          style: TextStyle(
                                            fontSize:  MediaQuery.of(context).size.width*0.04,
                                            color:Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),),
                                        onTap: () {

                                        }
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.comment),
                                      iconSize: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.0413,
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => CommentsScreen(user: user, post: posts[index]),),);
                                      },
                                    ),
                                    Text("${posts[index].comments.length}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:  MediaQuery.of(context).size.width*0.04,
                                        color:Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    SizedBox(width:MediaQuery.of(context).size.width*0.005),
                                    IconButton(
                                      icon: Icon(Icons.reorder),
                                      iconSize: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.0413,
                                      color: Colors.black,
                                      onPressed: () {
                                        showDialog(

                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              actions: [],
                                              content: Column(
                                                children:[

                                                  Padding(
                                                    padding:EdgeInsets.only(top:20),
                                                    child: Text(posts[index].details),
                                                  ),

                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        //  Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen( post: posts[index]),),);
                                      },
                                    ),
                                    SizedBox(width:MediaQuery.of(context).size.width*0.005),
                                    IconButton(
                                      icon: Icon(Icons.monetization_on),
                                      iconSize: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.046,
                                      onPressed: () {

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                PayScreen(
                                                  post: posts[index],
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    snapshot.data.id == user.id ?  Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          iconSize: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.046,
                                          onPressed: () {
                                            DeletePost(posts[index].id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    HomeScreen(
                                                      user: user,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ) : Row() ,
                                  ],
                                ),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02,),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02,),
                              Text("${posts[index].formatDate().day.toString().padLeft(2,'0')}-${posts[index].formatDate().month.toString()}-${posts[index].formatDate().year.toString().padLeft(2,'0')} ${posts[index].formatDate().hour.toString().padLeft(2,'0')}:${posts[index].formatDate().minute.toString().padLeft(2,'0')}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width*0.033,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,

                                ),),


                            ],
                          ),

                        ),

                      ],

                    ),

                  ),

                ),



              ) :  Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));
            }) : Container(height:0,width:0);



      },
    );
  }
}
