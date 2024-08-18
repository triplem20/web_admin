import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
 static const String id ="Splash-screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    Timer(Duration(seconds: 5), ()=>Navigator.pushNamed(context, HomeScreen.id) );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:  Hero(
          tag: 'logo',
          child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/logo1.jpg')),
          borderRadius: BorderRadius.circular(20),

                ),
              ),
        ),
      ),
    );
  }
}
