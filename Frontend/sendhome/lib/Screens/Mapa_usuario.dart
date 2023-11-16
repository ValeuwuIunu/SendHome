import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc ;
import 'package:provider/provider.dart';
import 'package:sendhome/Assistants/assistant_methods.dart';
import 'package:sendhome/Assistants/geofire_assistant.dart';
import 'package:sendhome/Screens/drawer_Screen.dart';
import 'package:sendhome/Screens/precise_pickup_location.dart';
import 'package:sendhome/Screens/rate_driver_screen.dart';
import 'package:sendhome/Screens/search_place_screen.dart';
import 'package:sendhome/global/global.dart';
import 'package:sendhome/global/map_key.dart';
import 'package:sendhome/infoHadler/app_info.dart';
import 'package:sendhome/models/active_nearby_available_drivers.dart';
import 'package:sendhome/splashScreen/splash_screen.dart';
import 'package:sendhome/widgets/progres_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/directions.dart';
import '../widgets/pay_fare_amount_dialog.dart';
Future<void> _makePhoneCall(String url) async{
  
  if(await canLaunch(url)){
    await launch(url);
  }
  else{
    throw"Could not launch $url";
  }
  
}

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({Key? key}) : super(key: key);
  @override
 State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {

  LatLng? pickLocation;
  loc.Location location =loc.Location();
  String? _addres;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();


  double searchLocationContainerHeight =200;
  double waitinResponsefromDrivercomtainerHeigth = 0;
  double assigneddriverInfoContainerHeight = 0;
  double suggestedRidesContainerHeight = 0;
  double searchingForDriverContainerHeight=0;

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

  DatabaseReference ? referenceRideRequest;

  String selectedVehicleType = "";

  String driverRideStatus="Driver is coming";
  StreamSubscription<DatabaseEvent>? tripRidesRequestInfoStreamSubscription;

  List<ActiveNearByAvailableDrivers>onlineNearByAvailableDriversList = [];

  String userRideRequestStatus="";
  bool requestPositionInfo=true;

  locateUserPosition () async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 15);


    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanRedableAdress = await AssistanMethods.searchAddressForGeographicCoordinate(userCurrentPosition!, context);
    print("This is our addres = " + humanRedableAdress );

    userName=userModelCurrentInfo!.nombre!;
    userEmail=userModelCurrentInfo!.correo!;
    initializeGeoFireListener();
    //AssistanMethods.readTripsKeysForOnlinerUser(context);

  }
  initializeGeoFireListener(){
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(userCurrentPosition!.latitude, userCurrentPosition!.longitude,10)!
        .listen((map) {
          print(map);
          if(map !=null){
            var callBack = map["callBack"];

            switch(callBack){

              //whenever any driver active / online
              case Geofire.onKeyEntered:
                   ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
                   activeNearByAvailableDrivers.locationLatitude=map["latitude"];
                   activeNearByAvailableDrivers.locationLongitude=map["longitude"];
                   activeNearByAvailableDrivers.driverId=map["key"];
                   print("-"*50);
                   print(map);
                   print("-"*50);
                   GeofireAssistant.activeNearByAvailableDriverList.add(activeNearByAvailableDrivers);
                   if(activeNearbyDriverKeysLoaded == true){
                        displayActiveDriversOnUserMap();
                   }
                   break;

             // whenever any driver become non-active/online
              case Geofire.onKeyExited:
                GeofireAssistant.deleteOfflineDriverFromlist(map["key"]);
                print("-"*50);
                print(map);
                print("-"*50);
                displayActiveDriversOnUserMap();
                break;

             //whenever driver moves - update driver location
              case Geofire.onKeyMoved:
                ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
                activeNearByAvailableDrivers.locationLongitude=map["longitude"];
                activeNearByAvailableDrivers.locationLatitude=map["latitude"];
                activeNearByAvailableDrivers.driverId = map["key"];
                GeofireAssistant.updateActiveNearByAvailableDriverLocation(activeNearByAvailableDrivers);
                print("-"*50);
                print(map);
                print("-"*50);
                displayActiveDriversOnUserMap();
                break;
               //dispaly those online active drivers on users map
              case Geofire.onGeoQueryReady:
                activeNearbyDriverKeysLoaded = true;
                displayActiveDriversOnUserMap();
                break;

            }
          }

          setState(() {

          });
    });
  }

  displayActiveDriversOnUserMap(){
    setState(() {
      markerSet.clear();
      circleSet.clear();

      Set<Marker>driversMarkerSet = Set<Marker>();

      for(ActiveNearByAvailableDrivers eachDriver in GeofireAssistant.activeNearByAvailableDriverList){
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
            markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }
      setState(() {
        markerSet = driversMarkerSet;
      });
    });
  }


  createdactiveNearByDriverIconMarker(BuildContext context) {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2),);
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/Imagen2.png').then((value) {
        activeNearbyIcon = value;
      });
    }
  }


  Future<void>drawPolyLineFromOriginToDestination() async{
    var originPosition  = Provider.of<AppInfo>(context,listen: false).userPickUpLocation;
    var destinationPosition  = Provider.of<AppInfo>(context,listen: false).userDropOffLocation;

    var originLatLng =LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng =LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) =>ProgresDialog(message: "Please wait",)
    );

    var directionDetailsInfo = await AssistanMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    setState(() {
      tripdirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints points = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList = points.decodePolyline(directionDetailsInfo.e_points!);

    plineCoordinatedList.clear();

    if(decodePolyLinePointsResultList.isNotEmpty){
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        plineCoordinatedList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.deepPurpleAccent,
        polylineId: PolylineId("PolylineId"),
        jointType: JointType.round,
        points: plineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5
      );

      polylineSet.add(polyline);
    });
    LatLngBounds boundslatlang;
    if(originLatLng.latitude >destinationLatLng.latitude && originLatLng.longitude>destinationLatLng.longitude){
      boundslatlang=LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude >destinationLatLng.longitude){
      boundslatlang = LatLngBounds(
          southwest: LatLng(originLatLng.latitude,destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude,originLatLng.longitude),
      );
    }
    else if(originLatLng.latitude>destinationLatLng.latitude){
      boundslatlang = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude,originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude,destinationLatLng.longitude),
      );
    }
    else{
      boundslatlang =LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundslatlang, 65));

    Marker originMarker = Marker(
        markerId: MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName,snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName,snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
        circleId: CircleId("originID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng
    );

    Circle destinationCircle = Circle(
        circleId: CircleId("destinationID"),
        fillColor: Colors.deepPurpleAccent,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: destinationLatLng
    );
    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });


  }

  void showSearchingForDriversContainer(){
    setState(() {
      searchingForDriverContainerHeight =200;
    });
  }

  void  showSuggestRidesContainer(){
    setState(() {
      suggestedRidesContainerHeight = 400;
      bottomPaddingOffMap =400;
    });
  }

  /*getAddressFromLatLng()async{
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
  }*/

  checkIfLocationPermissonAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  saveRideRequestInformation(String selectedVehicleType){
    //1.save the rideRequest Information

    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push();


    var originLocation = Provider.of<AppInfo>(context,listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context,listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key:value"
      "latitude":originLocation!.locationLatitude.toString(),
      "longitude":originLocation.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key:value"
      "latitude":destinationLocation!.locationLatitude.toString(),
      "longitude":destinationLocation.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin":originLocationMap,
      "destination":destinationLocationMap,
      "time":DateTime.now().toString(),
      "userName":userModelCurrentInfo!.nombre,
      "userPhone":userModelCurrentInfo!.celular,
      "originAddress":originLocation.locationName,
      "destinationAddress":destinationLocation.locationName,
      "driverId":"waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRidesRequestInfoStreamSubscription=referenceRideRequest!.onValue.listen((eventSnap) async {
      if(eventSnap.snapshot.value == null){
        return;
      }
      if((eventSnap.snapshot.value as Map)["car_details"] != null){
        setState(() {
          driveCarDetails = (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["driverPhone"] != null){
        setState(() {
          drivePhone = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["driverName"] != null){
        setState(() {
          driveName = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["raitings"] != null){
        setState(() {
          driveRatings = (eventSnap.snapshot.value as Map)["raitings"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["status"] != null){
        setState(() {
          userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["driverLocation"] != null){
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //status = accepted
        if(userRideRequestStatus =="accepted"){
          updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng);
        }
        //status = arrived
        if(userRideRequestStatus == "arrived"){
          setState(() {
            driverRideStatus = "Driver has arrived";
          });
        }

        //status = onTrip
        if(userRideRequestStatus =="ontrip"){
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        if(userRideRequestStatus =="ended"){
          if((eventSnap.snapshot.value as Map)["fareAmount"] != null){
            double fareAmount = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());

            var response = await showDialog(
                context: context,
                builder: (BuildContext context)=>PayFareAmountDialog(
                  fareAmount:fareAmount,
                )
            );

            if(response == "Cash Paid"){
              //user can rate the driver now
              if((eventSnap.snapshot.value as Map)["driverId"] !=null){
                String assignedDriverId=(eventSnap.snapshot as Map)["driverId"].toString();
                Navigator.push(context, MaterialPageRoute(builder: (c)=>RateDriverScreen(
                  assignedDriverId :assignedDriverId,
                )));

                referenceRideRequest!.onDisconnect();
                tripRidesRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }

    });

    onlineNearByAvailableDriversList = GeofireAssistant.activeNearByAvailableDriverList;
    searchNearestOnlineDrivers(selectedVehicleType);
  }

  searchNearestOnlineDrivers(String selectedVehicleType) async{

    if(onlineNearByAvailableDriversList.length==0){
      //cancel/delete the rideRequest Information
      referenceRideRequest!.remove();

      setState(() {
        polylineSet.clear();
        markerSet.clear();
        circleSet.clear();
        plineCoordinatedList.clear();
      });

      Fluttertoast.showToast(msg: "No online nearest Driver Available");
      Fluttertoast.showToast(msg: "Seacrh Again \n Restarting App");

      Future.delayed(Duration(milliseconds: 4000),(){
        referenceRideRequest!.remove();
        Navigator.push(context, MaterialPageRoute(builder: (c)=>SplashScreen()));
      });
      return;
    }

    await retrieveOnlineDriversinformation(onlineNearByAvailableDriversList);

    print("Driver List: "+ driversList.toString());

    for(int i=0;i < driversList.length;i++){
      if(driversList[i]["car_details"]["Tamaño Camion"] == selectedVehicleType){
        AssistanMethods.sendNotificationToDriverNow(driversList[i]["token"],referenceRideRequest!.key!,context);
        print(driversList[i]["token"]);
        print(driversList[i]["car_details"]["Tamaño Camion"]);
        print("si es");
      }
    }

    Fluttertoast.showToast(msg: "Notification sent Successfully");

    showSearchingForDriversContainer();

    await FirebaseDatabase.instance.ref().child("All Ride Requests").child(referenceRideRequest!.key!).child("driverId").onValue.listen((eventRideRequestSnapshot) {

      print("EventSnapshot: ${eventRideRequestSnapshot.snapshot.value}");
      if(eventRideRequestSnapshot.snapshot.value != null){
        if(eventRideRequestSnapshot.snapshot.value != "waiting"){
          showUIForAssignedDriverInfo();
        }

      }

    });
  }

  updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng) async{
    if(requestPositionInfo == true){
      requestPositionInfo=false;
      LatLng userPickUpPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo = await AssistanMethods.obtainOriginToDestinationDirectionDetails(
          driverCurrentPositionLatLng,
         userPickUpPosition,
      );

      if(directionDetailsInfo == null){
        return;
      }
      setState(() {
        driverRideStatus = "Driver is coming: " +directionDetailsInfo.distance_text.toString();
      });
      requestPositionInfo=true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {

    if(requestPositionInfo==true){
      requestPositionInfo=false;

      var dropOffLocation=Provider.of<AppInfo>(context,listen:false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(
          dropOffLocation!.locationLatitude!,
          dropOffLocation!.locationLongitude!
      );

      var directionDetailsInfo = await AssistanMethods.obtainOriginToDestinationDirectionDetails(
          driverCurrentPositionLatLng,
          userDestinationPosition
      );

      if(directionDetailsInfo == null){
        return;
      }

      setState(() {
        driverRideStatus= "Going Towards Destination: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo=true;
    }

  }

  showUIForAssignedDriverInfo(){
    setState(() {
      waitinResponsefromDrivercomtainerHeigth =0;
      searchLocationContainerHeight=0;
      assigneddriverInfoContainerHeight=200;
      suggestedRidesContainerHeight=0;
      bottomPaddingOffMap=200;
    });
  }

  retrieveOnlineDriversinformation(List onlineNearByAvailableDriversList) async {

    driversList.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");

    for (int i = 0;i < onlineNearByAvailableDriversList.length;i++){
      await ref.child(onlineNearByAvailableDriversList[i].driverId.toString()).once().then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;

        driversList.add(driverKeyInfo);
        print("driver key information = "+ driversList.toString());
      });
    }
  }



  @override
  void initState(){
    super.initState();
    checkIfLocationPermissonAllowed();
  }

  @override
  Widget build(BuildContext context) {
    //createdactiveNearByDriverIconMarker(context);
    return GestureDetector(
      onTap:(){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key:_scaffoldstate,
        drawer: DrawerScreen(),
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
             /* onCameraMove: (CameraPosition? position){
                if(pickLocation !=position!.target){
                  setState(() {
                    pickLocation=position.target;
                  });
                }
              },
              onCameraIdle: (){
                getAddressFromLatLng();
;              },*/
            ),
            /*Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.asset('assets/position.png',height: 45,width: 45,),
              ),
            ),*/


            //custom Hamburger button for drawer
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                child: GestureDetector(
                  onTap: (){
                    _scaffoldstate.currentState!.openDrawer();
                  },
                  child:CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu,
                      color: Color.fromRGBO(47, 8, 73, 0.5) ,
                    ),
                  ) ,
                ),
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
                            height: 120,
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
                                    SizedBox(
                                    height: 25.0,
                                    width: 30.0,
                                      child: IconButton(
                                        icon: Icon(Icons.location_on_outlined ,color:Color.fromRGBO(47, 8, 73, 0.5), size: 25.0),
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=>PrecisePickUpScreen()));

                                        },
                                      ),
                                    ),
                                        //(Icons.location_on_outlined ,color:Color.fromRGBO(47, 8, 73, 0.5),),
                                      SizedBox(width:10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Punto de partida",
                                            style: TextStyle(
                                              color: Color.fromRGBO(47, 8, 73, 0.5),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(Provider.of<AppInfo>(context).userPickUpLocation !=null
                                              ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)+"...":
                                              "No hay una dirección",
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
                                      await drawPolyLineFromOriginToDestination();
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 25.0,
                                          width: 43.0,
                                        child: Icon(Icons.location_on_outlined ,color : Color.fromRGBO(47, 8, 73, 0.5), size: 25.0),
                                        ),
                                        SizedBox(width:0.2),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Punto de llegada",
                                              style: TextStyle(
                                                color: Color.fromRGBO(47, 8, 73, 0.5),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            Text(Provider.of<AppInfo>(context).userDropOffLocation !=null
                                                ?Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                            :"¿A dónde lo llevamos?",
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
                          ),

                              SizedBox(width: 10,),

                              ElevatedButton(
                                onPressed: (){
                                  if(Provider.of<AppInfo>(context,listen: false).userDropOffLocation != null){
                                    showSuggestRidesContainer();
                                  }else{
                                    Fluttertoast.showToast(msg: "Please select destination location");
                                  }
                                },
                                child: Text(
                                  "Solicitar acarreo",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(47, 8, 73, 0.5),
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),


                                )
                              )
                            ],
                          ),
                              )
                        ],
                      ),
                    ),
            ),
      //ui for suggested rides
            Positioned(
              left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: suggestedRidesContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent ,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child:Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 15,),

                            Text(Provider.of<AppInfo>(context).userPickUpLocation !=null
                                ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)+"...":
                            "No hay una dirección",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.grey ,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child:Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 15,),

                            Text(Provider.of<AppInfo>(context).userDropOffLocation !=null
                                ?Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                :"¿A dónde lo llevamos?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text("Escoja un tamaño de camión",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedVehicleType="Pequeño";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedVehicleType == "Pequeño" ? (Colors.deepPurpleAccent):(Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(26.0),
                                  child: Column(
                                    children: [
                                      Image.asset('assets/Pequeño.jpg',scale: 2,),


                                      SizedBox(height: 4,width: 2,),

                                      Text(
                                          "X",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedVehicleType == "Pequeño" ? (Colors.white):(Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 2,),
                                      Text(
                                      tripdirectionDetailsInfo != null ? "\$ ${((AssistanMethods.calculateFareAmountFromOriginToDestination(tripdirectionDetailsInfo!)*0.8)*107).toStringAsFixed(1)}"
                                      :"null",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedVehicleType="Mediano";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedVehicleType == "Mediano" ? (Colors.deepPurpleAccent):(Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Column(
                                    children: [
                                      Image.asset('assets/Mediano.jpg',scale: 2,),


                                      SizedBox(height: 4,),

                                      Text(
                                        "XL",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedVehicleType == "Mediano" ? (Colors.white):(Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 2,),
                                      Text(
                                        tripdirectionDetailsInfo != null ? "\$ ${((AssistanMethods.calculateFareAmountFromOriginToDestination(tripdirectionDetailsInfo!)*1.5)*107).toStringAsFixed(1)}"
                                            :"null",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedVehicleType="Grande";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedVehicleType == "Grande" ? (Colors.deepPurpleAccent):(Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Column(
                                    children: [
                                      Image.asset('assets/Grande.jpg',scale: 2,),


                                      SizedBox(height: 4,),

                                      Text(
                                        "XXL",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedVehicleType == "Grande" ? (Colors.white):(Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 2,),
                                      Text(
                                        tripdirectionDetailsInfo != null ? "\$ ${((AssistanMethods.calculateFareAmountFromOriginToDestination(tripdirectionDetailsInfo!)*2)*107).toStringAsFixed(1)}"
                                            :"null",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                ),
                        ),
                SizedBox(height: 20,),

                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                if(selectedVehicleType!=""){
                                  saveRideRequestInformation(selectedVehicleType);
                                }else{
                                  Fluttertoast.showToast(msg: "Por favor escoge un tamaño \n de camión deseado.");
                                }
                              },
                              child:Container(
                                padding: EdgeInsets.all(12),
                                decoration:BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(10)
                                ) ,
                                child: Center(
                                  child: Text(
                                    "Solicitar camión",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ) ,
                            )
                        ),

                      ],
                    ),
                  ),
                )
            ),

            //Requesting a ride
            Positioned(
              bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: searchingForDriverContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          color: Colors.deepPurpleAccent,
                        ),

                        SizedBox(height: 10,),

                        Center(
                          child: Text(
                            "Buscando un conductor...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),

                        GestureDetector(
                          onTap: (){
                            referenceRideRequest!.remove();
                            setState(() {
                              searchingForDriverContainerHeight=0;
                              suggestedRidesContainerHeight=0;
                            });
                          },
                          child: Container(
                            height: 50,
                            width:50,
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(width: 1,color: Colors.grey)
                            ),
                            child: Icon(Icons.close,size:25,),
                          ),
                        ),

                        SizedBox(height: 15,),

                        Container(
                          width: double.infinity,
                          child: Text(
                            "Cancelar",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ),

      //Ui for displaying assigned driver information
      Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
          height: assigneddriverInfoContainerHeight,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(driverRideStatus,style: TextStyle(fontWeight:FontWeight.bold),),
                SizedBox(height: 5,),
                Divider(thickness: 1,color: Colors.grey[300],),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color : Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.person ,color: Colors.white),
                        ),
                        SizedBox(width: 10,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driveName,style: TextStyle(fontWeight: FontWeight.bold),),
                            Row(children: [
                              Icon(Icons.star,color: Colors.orange,),

                              SizedBox(width: 5,),

                              Text(driveRatings,
                              style:TextStyle(
                                color: Colors.grey
                              )
                              )
                            ],)
                          ],
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/Mediano.jpg', scale:3),
                        Text(driveCarDetails,style: TextStyle(fontSize: 12),),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 5,),
                Divider(thickness: 1,color:Colors.grey[300]),
                ElevatedButton.icon(
                    onPressed: (){
                      _makePhoneCall("tel: ${drivePhone}");
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),
                    icon: Icon(Icons.phone),
                    label:Text("Call Driver")
                )

              ],
            ),
          )
      )

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