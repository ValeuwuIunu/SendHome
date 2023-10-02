import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc ;
import 'package:sendhome/Assistants/assistant_methods.dart';
import 'package:sendhome/global/map_key.dart';


class MyMapScreen extends StatefulWidget {
  const MyMapScreen({Key? key}) : super(key: key);
  @override
 State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {

  LatLng? pickLocation;
  loc.Location location =loc.Location();
  String? _addres;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();


  double searchLocationContainerHeight =200;
  double waitinResponsefromDrivercomtainerHeigth = 0;
  double assigneddriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOffMap =0;

  List<LatLng> plineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker>markerSet ={};
  Set<Circle>circleSet ={};

  String userName="";
  String userEmail="";

  bool openNavigationDrawer =true;
  bool activeNearbyDriverKeysLoaded = true;
  BitmapDescriptor? activeNearbyIcon;


  locateUserPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 15);
    
    
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanRedableAdress = await AssistanMethods.searchAddressForGeographicCoordinate(userCurrentPosition!, context);
    print("This is our addres = " + humanRedableAdress );

  }
  getAddressFromLatLng()async{
    try{
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey
      );
      setState(() {
        _addres = data.address;
        print("addres ${_addres}");
      });
    }catch(exe){
      print(exe);
    }
  }

  checkIfLocationPermissonAllowed()async {
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void initState(){
    super.initState();
    checkIfLocationPermissonAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
              onMapCreated: (GoogleMapController controller){
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {

                });

                locateUserPosition();
              },
              onCameraMove: (CameraPosition? position){
                if(pickLocation !=position!.target){
                  setState(() {
                    pickLocation=position.target;
                  });
                }
              },
              onCameraIdle: (){
                getAddressFromLatLng();
;              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.asset('assets/position.png',height: 45,width: 45,),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(20),
                child: Text(_addres ?? "Set your picuplocation",
                  overflow:TextOverflow.visible,softWrap:true,
                ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}