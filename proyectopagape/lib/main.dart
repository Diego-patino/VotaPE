import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/home.dart';
import 'package:pagapetodo/pages/candidatos.dart';



Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   Firebase.initializeApp().then((value) => 
    runApp(MyApp()));
  // await Firebase.initializeApp(options: firebaseOptions);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: home(),
    );
  }
}
