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

class PayScreen extends StatefulWidget {
  final Post post;
  const PayScreen({Key key,this.post}) : super(key: key);

  @override
  State<PayScreen> createState() => PayScreenState(post:post);
}

class PayScreenState extends State<PayScreen> {
  final Post post;
  PayScreenState({Key key,this.post});
  TextEditingController _amount;
  var value = "";
  var _paymentItems = <PaymentItem>[];

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: "");
    _amount.addListener(() {
      setState(() {
        value = _amount.text;
      });
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onGooglePayResult(paymentResult) {
      EditPost(post, int.parse(paymentResult.toString()));
      Navigator.pop(context);
    }

    return Scaffold(

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Text(
                'Bağış miktarı ${value} TL',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _amount,
                expands: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tutar",
                  hintText: "Tutarı giriniz",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                maxLength: 10,
                mouseCursor: MaterialStateMouseCursor.clickable,
                onChanged: (text) {
                  setState(() {
                    value = text;
                  });
                },
              ),
            ),
            Center(
                child: GooglePayButton(
                  paymentItems: _paymentItems,
                  style: GooglePayButtonStyle.white,
                  type: GooglePayButtonType.donate,
                  onPaymentResult: onGooglePayResult,
                  onError: (error) {
                    print(error);
                  },
                  onPressed: () => {
                    print(value),
                    _paymentItems.add(PaymentItem(
                        amount: value,
                        label: 'bagis',
                        status: PaymentItemStatus.final_price))

                  },
                  paymentConfigurationAsset: "gpay.json",
                  height: 50,
                  width: 200,
                )),
          ],
        ),
      ),
    );
  }
}