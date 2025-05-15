import 'package:flutter/material.dart';
import 'package:rideconnect/Landing%20Pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
//ensure flutter is initialized
WidgetsFlutterBinding.ensureInitialized();
//initialize the firebase
await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}