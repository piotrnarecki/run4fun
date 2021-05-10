import 'package:flutter/material.dart';
import 'package:run4fun/login_route.dart';
import 'settings_route.dart';
import 'training_route.dart';
import 'login_route.dart';

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



  // tutaj metoda sprawdzająca czy użytkownik jest zalogowany

  // metoda wyswietlanjaca imię i statystki użytkownika



  runApp(MaterialApp(
    title: 'Navigation Basics',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: MainRoute(),
  ));
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
            child: Text('Training'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (TrainingRoute())),
              );
            },
          ),
          ElevatedButton(
            child: Text('Login'), // ten przycisk nie działa !!!
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (LoginRoute())),
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
