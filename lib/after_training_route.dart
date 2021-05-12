import 'package:flutter/material.dart';

import 'main.dart';

import 'settings_route.dart';
import 'training_route.dart';

import 'login_route.dart';

// W TEJ KLASIE BEDZIE WYSWIETLANE PODSUMOWANIE TRENINGU I DANE BEDA PRZESYLANE DO BAZY

// TUTAJ DANE PRZESYLANE DO BAZY DANYCH

class AfterTraining extends StatelessWidget {
  void sendTrainingToDatabase() {

    // dane treningu będą odczytywane z globalnej tablicy zapisanej w pamieci urzadzenia

    // tutaj ma wysyłać trening do bazy danych trening
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
        theme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              title: Text('After training route'),
            ),
            body: Center(
              child: Column(children: [
                ElevatedButton(
                  child: Text('Main route'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (LoginRoute())),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Send training to database'),
                  onPressed: () {
                    sendTrainingToDatabase();
                  },
                ),
              ]),
            )));
  }
}
