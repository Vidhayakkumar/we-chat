import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/helper/routes.dart';
import '../auth/login_page.dart';

late Size mq;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      Future.delayed(const Duration(seconds: 3), () {

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,statusBarColor: Colors.white)
        );

        if (user != null) {
          Navigator.pushReplacementNamed(context, AppRoutes.homePage);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset("assets/images/group.png"),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("MADE IN INDIA BY"),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset("assets/images/india.png"),
                    ),
                    const SizedBox(width: 20),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      AssetImage("assets/images/vidh.jpeg"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
