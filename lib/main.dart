import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/model/counter_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/provider/firebase_provider.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:flutter_app_location_todo/ui/location_todo_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_location_todo/ui/login_page.dart';
import 'package:flutter_app_location_todo/ui/planner_page.dart';
import 'package:flutter_app_location_todo/ui/signin_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CP()),
        ChangeNotifierProvider(create: (context) => OnOff()),
        ChangeNotifierProvider(create: (context) => DivideCounter()),
        ChangeNotifierProvider(create: (context) => FirebaseProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TIMWORK',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Color.fromRGBO(255, 176, 0, 1),
            textTheme: TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700))),
      ),
      home: SignInPage(),
      // home: LoginScreen(),
      // home: LocationTodo(),
    );
  }
}
