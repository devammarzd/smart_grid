import 'package:flutter/material.dart';
import 'package:smart_grid/Global.dart';
import 'package:smart_grid/Screens/Login.dart';
import 'package:smart_grid/Screens/RoomsInput.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false, 
      theme: ThemeData(
     
        primaryColor: primaryColor
  
     
      ),
     home: Login(),
    );
  }
}

