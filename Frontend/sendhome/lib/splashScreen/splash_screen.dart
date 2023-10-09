import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendhome/Assistants/assistant_methods.dart';
import 'package:sendhome/global/global.dart';

import '../Screens/LoginScreen.dart';
import '../Screens/Mapa_usuario.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) :super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async{
      if(await firebaseAuth.currentUser != null){
        firebaseAuth.currentUser != null? AssistanMethods.readCurrendOnLineUserInfo():null;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MyMapScreen()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    });
  }

  @override
  void initState(){
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Send Home!',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent,
          ),
        ),
      ),
    );
  }
}
