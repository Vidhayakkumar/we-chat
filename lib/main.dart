import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:we_chat/helper/routes.dart';
import 'package:we_chat/screens/SplashScreen.dart';
import 'package:we_chat/service_locator.dart';

import 'firebase_options.dart';
late Size mq;
void main()async   {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await initializeDependencies();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'We Chat',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.normal,
            color: Colors.black,

          )
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.getRoutes()
    );
  }
}
