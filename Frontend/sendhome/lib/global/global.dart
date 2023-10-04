import 'package:firebase_auth/firebase_auth.dart';
import 'package:sendhome/models/user_model.dart';

import '../models/direction_detail_info.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;


DirectionDetailsInfo? tripdirectionDetailsInfo;
String userDropOffAddress="";