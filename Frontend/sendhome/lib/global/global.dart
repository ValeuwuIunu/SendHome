import 'package:firebase_auth/firebase_auth.dart';
import 'package:sendhome/models/user_model.dart';

import '../models/direction_detail_info.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

List driversList = [];
String cloundMessagingServerToken= "key=AAAAHzrHTd4:APA91bE-wjTAU7PZE9ZYsWQMOC51QhuFIVw0xvVNiuPrZkz_jxNGH8c48V7uFp4CmG0aTyNLK1BRgd8Ly25HLSd2sFK9Oft7X6eJQLtPn97R4rPvI_Om9mY17eI2lZCfA3uBIMnA5vJ1";
DirectionDetailsInfo? tripdirectionDetailsInfo;
String userDropOffAddress="";
String driveCarDetails="";
String driveName="";
String drivePhone="";

double countRatingStars=0.0;
String titleStarsRating = "";