import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc ;
import 'package:provider/provider.dart';
import 'package:sendhome/Assistants/assistant_methods.dart';
import 'package:sendhome/Screens/search_place_screen.dart';
import 'package:sendhome/global/global.dart';
import 'package:sendhome/global/map_key.dart';
import 'package:sendhome/infoHadler/app_info.dart';

import '../models/directions.dart';


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
  double bottomPaddingOffMap = 50;

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

    userName=userModelCurrentInfo!.nombre!;
    userEmail=userModelCurrentInfo!.correo!;

    //initializeGeoFireListener();
    //AssistanMethods.readTripsKeysForOnlinerUser(context);

  }
  getAddressFromLatLng()async{
    try{
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey
      );
      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;
        Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
        //_addres = data.address;
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
              padding: EdgeInsets.only(top: 40,bottom: bottomPaddingOffMap),
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
           //ui for searching location
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined ,color : Colors.deepPurpleAccent),
                                      SizedBox(width:10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("From",
                                            style: TextStyle(
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(Provider.of<AppInfo>(context).userPickUpLocation !=null
                                              ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)+"...":
                                              "Not get adresss",
                                            style: TextStyle(color: Colors.grey,fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () async{
                                      //go to search place screen
                                      var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchPlaceScreen()));

                                      if(responseFromSearchScreen == "obtainDropoff"){
                                        setState(() {
                                          openNavigationDrawer=false;
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined ,color : Colors.deepPurpleAccent),
                                        SizedBox(width:10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("To",
                                              style: TextStyle(
                                                color: Colors.deepPurpleAccent,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(Provider.of<AppInfo>(context).userDropOffLocation !=null
                                                ?Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                            :"where to?",
                                              style: TextStyle(color: Colors.grey,fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
           
           
           /* Positioned(
              top: 40,
              right: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(20),
                child: Text(
                  Provider.of<AppInfo>(context).userPickUpLocation !=null
                      ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)+"...":"Not get adresss",
                  overflow:TextOverflow.visible,softWrap:true,
                ),
                ),
              ),*/


          ],
        ),
      ),
    );
  }
}