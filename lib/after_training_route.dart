import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/training_on_map_route.dart';

import 'login_route.dart';

import 'dart:core';
import 'training_summary.dart';

// W TEJ KLASIE BEDZIE WYSWIETLANE PODSUMOWANIE TRENINGU I DANE BEDA PRZESYLANE DO BAZY

// TUTAJ DANE PRZESYLANE DO BAZY DANYCH

class AfterTraining extends StatelessWidget {
  AfterTraining(List<Object> trainingList) : this.trainingList = trainingList;
  final List<Object> trainingList;
  //final List<String> trainingListString=[trainingList[0],trainingList[1],trainingList[2]];




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
                TrainingSummary(trainingList),

                // ElevatedButton(
                //   child: Text('see last training details'),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => (TrainingOnMap())),
                //     );
                //   },
                // ),

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
                        //trainingList: trainingList,
                        trainingList: ["trening","data","dystans"],

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
