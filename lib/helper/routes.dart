import 'package:flutter/material.dart';
import 'package:we_chat/auth/login_page.dart';
import 'package:we_chat/auth/sigup_page.dart';
import 'package:we_chat/screens/HomeScreen.dart';
import 'package:we_chat/screens/SplashScreen.dart';
import 'package:we_chat/screens/chat_section.dart';
import 'package:we_chat/screens/profile_screen.dart';

import '../model/chat_user_model.dart';

class AppRoutes{


  static const String splashScreen = '/splash';
  static const String signUpPage = '/sigUpPage';
  static const String loginPage = '/loginPage';
  static const String homePage = '/homePage';
  static const String chatSection = '/chatSection';
  static const String profileScreen = "profile";

  static Map<String , Widget Function(BuildContext context)> getRoutes()=>{
    splashScreen : (context) => SplashScreen(),
    signUpPage : (context) => SignUpPage(),
    loginPage : (context) => LoginPage(),
    homePage : (context) => HomeScreen(),
  };

}