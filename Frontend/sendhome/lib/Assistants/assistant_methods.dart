import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sendhome/Assistants/request_assistant.dart';
import 'package:sendhome/global/global.dart';
import 'package:sendhome/models/directions.dart';
import 'package:sendhome/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../global/map_key.dart';
import '../infoHadler/app_info.dart';
import '../models/direction_detail_info.dart';

class AssistanMethods{
  
  static void readCurrendOnLineUserInfo() async{
    
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value !=null){
        userModelCurrentInfo =UserModel.fromSnapshot(snap.snapshot);
      }
    });

  }


  static Future<String> searchAddressForGeographicCoordinate(Position position,  context) async {
    String apiUrl = "https://maps.google.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if (requestResponse != "Error Occurred. Failed. No Response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      // Aquí puedes usar Provider para actualizar la ubicación de recogida si es necesario.
      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }else{
      print("Error");
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo>obtainOriginToDestinationDirectionDetails(LatLng originPosition,LatLng destinationposition)async{

    String urlOriginToDestinationDirectionDetails="https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationposition.latitude},${destinationposition.longitude}&key=$mapKey";


    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);
    //if(responseDirectionApi =="Error Ocurred.Failesd No Response"){
      //return;
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    print("Entre");
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text=responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value=responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text=responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value=responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];


    return directionDetailsInfo;

  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo) {
    // Supongamos que la tarifa de Didi Colombia es de 1000 pesos colombianos por minuto y 500 pesos colombianos por kilómetro.
    double timeTravelFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 10;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.distance_value! / 1000) * 500;

    // Calcula la tarifa en pesos colombianos
    double totalFareAmountInPesos = timeTravelFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;

    return double.parse(totalFareAmountInPesos.toStringAsFixed(1));
  }


  static sendNotificationToDriverNow(String deviceRegistrationToken,String userRideRequestId,context) async{
    String destinationAddress = userDropOffAddress;

    Map<String,String>headerNotification = {
      'Content-Type':'application/json',
      'Authorization':cloundMessagingServerToken,
    };

    Map bodyNotification ={
      "body":"Destination Address: \n $destinationAddress.",
      "title":"New Trip Request"
    };

    Map dataMap = {
      "click_action":"FLUTTER_NOTIFICATION_CLICK",
      "id":"1",
      "status":"done",
      "rideRequestId":userRideRequestId
    };

    Map officialNotificationFormat ={
      "notification":bodyNotification,
      "data":dataMap,
      "priority":"high",
      "to":deviceRegistrationToken
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),

    );
  }


}