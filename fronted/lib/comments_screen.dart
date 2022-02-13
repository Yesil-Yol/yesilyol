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
import 'json.dart';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

class CommentsScreen extends StatefulWidget {
  final Post post;
  final User user;
  const CommentsScreen({Key key,this.post,this.user}) : super(key : key);

  @override
  CommentsScreenState createState() => CommentsScreenState(user : user,post : post);
}

class CommentsScreenState extends State<CommentsScreen> {
  final Post post;
  final User user;
  CommentsScreenState({Key key,this.post,this.user});
  final TextEditingController _comment= TextEditingController();
  Future fetchCommentsfuture;

  Future<void> RefreshList(){
    Navigator.push(
      context ,
      MaterialPageRoute(
        builder: (_) => CommentsScreen(
            user : user,post : post
        ),
      ),
    );
  }

  @override
  // ignore: must_call_super
  void initState() {
    fetchCommentsfuture = FetchComments(http.Client(),post.id);
  }



  @override


  Widget build(BuildContext context) {



    return Scaffold(




      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[


            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                ),
              ),
              child: Column(

                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height*0.05),

                  Text(
                    'Yorumlar',
                    style: TextStyle(
                      color:Colors.black,
                      fontSize: MediaQuery.of(context).size.height*0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*1,
                    child: FutureBuilder<List<Comment>>(
                      future: fetchCommentsfuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData ? CommentsList(comments:snapshot.data,post:post,user:user,
                          //  author: post.comment
                        )
                            :
                        Center(child: Text(''));
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.5),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          height: 60.0,
          color: Colors.white,
          child: Row(
            children: <Widget>[

              Expanded(
                child: TextField(
                  controller: _comment,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {},
                  decoration: InputDecoration.collapsed(
                    hintText: 'Yorum Yaz',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                iconSize: 26,
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    CreateComment(user.id,post.id,_comment.text);
                    _comment.clear();
                    Future.delayed(new Duration(seconds:1), ()
                    {  RefreshList();}
                    );});},),
            ],
          ),
        ),
      ),

    );
  }

}

class CommentsList extends StatefulWidget {
  final Post post;
  final User user;
  final List<Comment> comments;
  const CommentsList({Key key,this.comments,this.post,this.user}) : super(key : key);

  @override
  CommentsListState createState() => CommentsListState(user : user,post : post,comments:comments,key:key);
}

class CommentsListState extends State<CommentsList> {
  final Post post;
  final User user;
  final List<Comment> comments;
  final List<dynamic> author;

  @override
  Future<User> callUser(String userid) async {
    Future<User> _user = FetchUser(userid);
    return _user;
  }

  Future<void> RefreshList(){
    Navigator.push(
      context ,
      MaterialPageRoute(
        builder: (_) => CommentsScreen(
            user : user,post : post
        ),
      ),
    );
  }

  CommentsListState({Key key, this.author,this.comments,this.post,this.user});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: RefreshList ,
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return FutureBuilder<User>(
              future: callUser(comments[index].authorstring),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData ? Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.008),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: MediaQuery.of(context).size.height*0.035,
                      backgroundImage: NetworkImage(snapshot.data.image == null ? 'https://st2.depositphotos.com/4111759/12123/v/600/depositphotos_121233262-stock-illustration-male-default-placeholder-avatar-profile.jpg' : snapshot.data.image),

                    ),

                    subtitle:
                    Column(
                      crossAxisAlignment :CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:  EdgeInsets.all(MediaQuery.of(context).size.height*0.005),
                          child: Stack(
                            children: <Widget>[
                              Padding(

                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.height*0.0),
                                child: Column(
                                  crossAxisAlignment :CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {},
                                          child:
                                          Row(
                                            children: [
                                              Text(
                                                '${snapshot.data.fullname}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:  Colors.black,
                                                  fontSize: MediaQuery.of(context).size.height*0.03,
                                                ),
                                              ),
                                              SizedBox(width: MediaQuery.of(context).size.width*0.08,),

                                            ],
                                          ),

                                        ),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${comments[index].content}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:  Colors.black,
                                            fontSize: MediaQuery.of(context).size.height*0.023,
                                          ),
                                        ),
                                        snapshot.data.id == user.id ? IconButton(
                                          icon: Icon(Icons.delete ),
                                          iconSize: MediaQuery.of(context).size.height*0.03,
                                          color:Colors.black ,
                                          onPressed: (){
                                            DeleteComment(comments[index].id);
                                            Future.delayed(new Duration(seconds:1), ()
                                            {
                                              Navigator.push(
                                                context ,
                                                MaterialPageRoute(
                                                  builder: (_) => CommentsScreen(
                                                      user : user,post:post
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        ) : Container(),
                                      ],
                                    ),
                                    //SizedBox(height: MediaQuery.of(context).size.height*0.005),




                                  ],
                                ),

                              ),

                            ],
                          ),
                        )
                      ],
                    ),






                  ),
                ) :  Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));
              });


        },
      ),
    );
  }
}