import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/training_on_map_route.dart';

import 'login_route.dart';

import 'dart:core';
import 'training_summary.dart';
import 'trainingModel.dart';
import 'history_route.dart';

// W TEJ KLASIE BEDZIE WYSWIETLANE PODSUMOWANIE TRENINGU I DANE BEDA PRZESYLANE DO BAZY

// TUTAJ DANE PRZESYLANE DO BAZY DANYCH

class AfterTraining extends StatelessWidget {
  // AfterTraining(List<String> trainingList) : this.trainingList = trainingList;
  // final List<String> trainingList;

  AfterTraining(TrainingModel trainingModel)
      : this.trainingModel = trainingModel;
  final TrainingModel trainingModel;

  List<String> trainingList = [];

  void sendTrainingToDatabase() {
    // dane treningu będą odczytywane z globalnej tablicy zapisanej w pamieci urzadzenia

    // tutaj ma wysyłać trening do bazy danych trening
  }

  List<String> getTrainingData(TrainingModel trainingModel) {
    var endDate = trainingModel.endDate;
    var totalTime = trainingModel.totalTime; //s
    var totalDistance = trainingModel.totalDistance; //m

    var avgSpeed = trainingModel.avgSpeed; // km/h
    var avgPace = trainingModel.avgPace; // min/km
    var kilocalories = trainingModel.kilocalories; //kcal

    List<String> trainingList = [
      endDate.toString(),
      totalTime.toString(),
      totalDistance.toString(),
      avgSpeed.toString(),
      avgPace.toString(),
      kilocalories.toString(),
    ];

    return trainingList;
  }

  @override
  Widget build(BuildContext context) {
    // trainingList=

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Podsumowanie'),

              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (LoginRoute())),
                    );
                  },
                )
              ],


            ),
            body: Center(
              child: ListView(children: [
                TrainingSummary(trainingModel),

                // ElevatedButton(
                //   child: Text('see last training details'),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => (TrainingOnMap())),
                //     );
                //   },
                // ),

                // ElevatedButton(
                //   child: Text('powrót'),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => (LoginRoute())),
                //     );
                //   },
                // ),

                ElevatedButton(
                  child: Text('historia treningów'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (HistoryRoute())),
                    );
                  },
                ),



                // /***
                //     ElevatedButton(
                //     child: Text('Send training to database'),
                //     onPressed: () {
                //  */
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GuestBook(
                        addMessage: (String message) =>
                            appState.addMessageToGuestBook(message),
                        messages: appState.guestBookMessages,
                        // trainingList: trainingList,
                        // trainingList: ["trening","data","dystans"],
                        trainingList: getTrainingData(trainingModel),
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
