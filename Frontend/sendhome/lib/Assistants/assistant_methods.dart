import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sendhome/Assistants/request_assistant.dart';
import 'package:sendhome/global/global.dart';
import 'package:sendhome/models/directions.dart';
import 'package:sendhome/models/user_model.dart';

import '../global/map_key.dart';
import '../infoHadler/app_info.dart';

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
}