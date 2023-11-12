import 'package:firebase_auth/firebase_auth.dart';
import 'package:sendhome/models/user_model.dart';

import '../models/direction_detail_info.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

List driversList = [];
String cloundMessagingServerToken= "key=AAAAHzrHTd4:APA91bFQq04rdAQjSiAZID0t6BxpGS9X5X1SOcM8KrCjybCXlwSWdAb3EUe2AjafHh3ZV9CmS9EvayEk-cV2D_ihaTihNPj5cs8gM7XceVLs8T4VrXdEJVcKFa8v_Fw6xKaDi96AY0wu";
DirectionDetailsInfo? tripdirectionDetailsInfo;
String userDropOffAddress="";
String driveCarDetails="";
String driveName="";
String drivePhone="";

double countRatingStars=0.0;
String titleStarsRating = "";