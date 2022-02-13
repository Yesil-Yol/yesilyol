import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'recycle_bin_details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'create_recycle_bin_screen.dart';
import 'home_screen.dart';
import 'json.dart';
import 'models.dart';
const SERVER_IP = 'http://10.0.2.2:8000';
const String googleAPIKey = 'AIzaSyDHshz1NHLVjH1fcZihfMqqZFIYyghfWV0';

class FeedScreenMap extends StatefulWidget {
  final User user;
  const FeedScreenMap({Key key, this.user,}) : super(key: key);

  @override
  FeedScreenMapState createState() => FeedScreenMapState(user: user);
}

class FeedScreenMapState extends State<FeedScreenMap> {
  final User user;
  FeedScreenMapState({Key key, this.user,});
  Future<List<RecycleBin>> fetchPostsfuture;




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
    fetchPostsfuture = FetchRecycleBins(http.Client(),user);
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(


      body: RefreshIndicator(
        onRefresh: refreshlist,
        child: FutureBuilder<List<RecycleBin>>(
          future: fetchPostsfuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData ? MapScreen(bins: snapshot.data,user:user)
                :
            Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));

          },
        ),
      ),
    );
  }


}

class MapScreen extends StatefulWidget {
  final User user;
  final List<RecycleBin> bins;
  MapScreen({this.user,this.bins,Key key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState(user:user,bins:bins);
}

class MapScreenState extends State<MapScreen> {
  final User user;
  final List<RecycleBin> bins;
  MapScreenState({this.user,this.bins,Key key});
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  List<Marker> admarkers = [];
  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;
  Location _location = Location();
  Location currentLocation = Location();
  static final CameraPosition initialLocation = CameraPosition(target: LatLng(37.42358913584007, -122.08711858838798), zoom: 14.4746);

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
  }


  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  _advertisements(List<RecycleBin> ads) {
    List<Marker> markers = [];
    if (_origin != null){markers.add(_origin);}
    if (_destination != null){markers.add(_destination);}
    if (marker != null){markers.add(marker);}
    for(int i=0;i<ads.length;i++){
      if(ads[i].isactivated ){
        markers.add(Marker(
            markerId:  MarkerId('${ads[i].author}'),
            infoWindow:  InfoWindow(title: '${ads[i].author}'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            position: LatLng(double.parse(ads[i].locationlat),double.parse(ads[i].locationlng)),

            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BinDetailScreen(bin:ads[i]
              )));
            }
        ));
      }

    }
    return Set.of(markers);

  }

  void _addMarker(LatLng pos) async {

    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
            markerId: const MarkerId('Yeni Geri Dönüşüm Kutunuz!'),
            infoWindow: const InfoWindow(title: 'Yeni Geri Dönüşüm Kutunuz!'),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: pos,
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateRecycleBinScreen(user: user,lat:_origin.position.latitude,
                  lng:_origin.position.longitude
              )));

            }
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    }

  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    getCurrentLocation();
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.hybrid,
            indoorViewEnabled: false,
            initialCameraPosition: initialLocation,
            markers: _advertisements(bins),
            circles: Set.of((circle != null) ? [circle] : []),
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
            onMapCreated: _onMapCreated,

          ),





        ],
      ),

    );
  }
}
