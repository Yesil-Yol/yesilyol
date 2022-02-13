import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

class BinDetailScreen extends StatefulWidget {
  final RecycleBin bin;
  const BinDetailScreen({Key key,this.bin}) : super(key : key);

  @override
  BinDetailScreenState createState() => BinDetailScreenState(bin:bin);
}

class BinDetailScreenState extends State<BinDetailScreen> {
  final RecycleBin bin;
  BinDetailScreenState({Key key,this.bin});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:150),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width* 0.043,
                vertical: 0,
              ),
              child: Image.network(bin.image),
            ),
          ],
        ),
      ),
    ) ;

  }
}