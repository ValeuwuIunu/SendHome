import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sendhome/infoHadler/app_info.dart';
import 'package:sendhome/splashScreen/splash_screen.dart';

import 'Screens/LoginScreen.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>AppInfo() ,
      child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(primary: Colors.green),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
          ),
          home: SplashScreen(),
          //SplashScreen()
        ),
    );
  }
}