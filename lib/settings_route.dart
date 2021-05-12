import 'package:flutter/material.dart';
import 'login_route.dart';
import 'main.dart';

import 'settings_route.dart';
import 'training_route.dart';


// W TEJ KLASIE BEDZA USTAWIANE TAKIE PARAMETRY UZYTKOWNIKA JAK MASA CZY WZROST (MASA POTRZEBNA DO WYLICZNENIA SPALONYCH KALORI)





class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Settings Route'),
          ),
          body: Center(
            child: ElevatedButton(
              child: Text('Main route'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (LoginRoute())),
                );
              },
            ),
          ),
        ));
  }
}
