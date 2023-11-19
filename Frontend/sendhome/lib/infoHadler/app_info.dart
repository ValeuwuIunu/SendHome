import 'package:flutter/cupertino.dart';
import 'package:sendhome/models/trip_history_model.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;



  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel>allTripsHistoryInformationList = [];


  void updatePickUpLocationAddress(Directions userPickUpAddres){
    userPickUpLocation = userPickUpAddres;
    notifyListeners();

  }

  void updateDropOffLocationAddres(Directions dropOffAddres){
    userDropOffLocation = dropOffAddres;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter){
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripKeysList){

    historyTripsKeysList = tripKeysList;
    notifyListeners();

  }

  updateOverAllTripHistoryInformation(TripsHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();

  }


}