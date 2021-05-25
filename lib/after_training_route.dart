import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/widgets.dart';

import 'main.dart';

import 'settings_route.dart';
import 'training_route.dart';

import 'login_route.dart';

import 'dart:core';

// W TEJ KLASIE BEDZIE WYSWIETLANE PODSUMOWANIE TRENINGU I DANE BEDA PRZESYLANE DO BAZY

// TUTAJ DANE PRZESYLANE DO BAZY DANYCH

class AfterTraining extends StatelessWidget {
  AfterTraining(List<String> trainingList) : this.trainingList = trainingList;
  final List<String> trainingList;

  void sendTrainingToDatabase() {
    // dane treningu będą odczytywane z globalnej tablicy zapisanej w pamieci urzadzenia

    // tutaj ma wysyłać trening do bazy danych trening
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text('After training route'),
            ),
            body: Center(
              child: ListView(children: [
                ElevatedButton(
                  child: Text('Main route'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (LoginRoute())),
                    );
                  },
                ),
                /***
                    ElevatedButton(
                    child: Text('Send training to database'),
                    onPressed: () {
                 */
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GuestBook(
                        addMessage: (String message) =>
                            appState.addMessageToGuestBook(message),
                        messages: appState.guestBookMessages,
                        trainingList: trainingList,
                      ),
                    ],
                  ),
                ),
                /**
                    sendTrainingToDatabase();

                    }
                    ),
                 */
              ]),
            )));
  }
}
