import 'package:flutter/material.dart';
import 'settings_route.dart';
import 'training_route.dart';
import 'database.dart';



import 'package:flutter/material.dart';




import 'package:google_fonts/google_fonts.dart';



import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets.dart';
import 'authentication.dart';



void main() {
//  runApp(MaterialApp(
//    title: 'Navigation Basics',
//    debugShowCheckedModeBanner: false,
//    theme: ThemeData.dark(),
//    home: MainRoute(),
//  ));



  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );


//  runApp(
//    ChangeNotifierProvider(
//      create: (context) => ApplicationState(),
//      builder: (context, _) => App(),
//    ),
//  );

}
// W TEJ KLASIE BEDZIE WYSWIETLANY GLOWNY EKRAN Ekran

class MainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run 4 Fun'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('database'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (App())),
              );
            },
          ),
          ElevatedButton(
            child: Text('Settings'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (SettingsRoute())),
              );
            },
          ),
        ],
      )),
    );
  }
}
