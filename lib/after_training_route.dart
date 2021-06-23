import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/training_on_map_route.dart';
import 'package:run4fun/widgets.dart';
import 'login_route.dart';
import 'dart:core';
import 'training_summary.dart';
import 'trainingModel.dart';
import 'history_route.dart';

// ta klasa odpowiedzialna za wyswietlanie podsumowania  treningu i opcje wysylania go do bazy danych
class AfterTraining extends StatelessWidget {
  AfterTraining(TrainingModel trainingModel)
      : this.trainingModel = trainingModel;
  final TrainingModel trainingModel;

  List<String> trainingList =
      []; // lista parametrow treningu przekazywana do bazy danych

// metoda, ktora na podstawie obiektu TrainingModel uwtorzonego po treningu tworzy liste parametrow treningu
  List<String> getTrainingData(TrainingModel trainingModel) {
    var endDate = trainingModel.endDate; //data treningu
    var totalTime = trainingModel.totalTime; //czas calkowity [s]
    var totalDistance = trainingModel.totalDistance; //odleglosc calkowita [m]

    var avgSpeed = trainingModel.avgSpeed; //predkosc srednia [km/h]
    var avgPace = trainingModel.avgPace; // tempo srednie [min/km]
    var kilocalories =
        trainingModel.kilocalories; //ilosc spalonych kalorii [kcal]

    List<String> trainingList = [
      endDate.toString(),
      totalTime.toString(),
      totalDistance.toStringAsFixed(2),
      avgSpeed.toStringAsFixed(2),
      avgPace.toStringAsFixed(2),
      kilocalories.toStringAsFixed(2),
    ];

    return trainingList;
  }

  // metoda otwierajaca ekran, w ktorym trening jest pokazany na mapie
  void showTrainingOnMap(trainingModel, context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (TrainingOnMap(trainingModel))),
    );
  }

  @override
  Widget build(BuildContext context) {
    trainingList = getTrainingData(trainingModel);
    var KCAL = trainingList[5];
    var PACE = trainingList[4];
    var SPEED = trainingList[3];
    var DISTANCE = trainingList[2];
    var TIME = trainingList[1];
    var DATE = trainingList[0];

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
                StyledButton(
                  onPressed: () {
                    showTrainingOnMap(trainingModel, context);
                  },
                  child: Text('pokaż na mapie'),
                ),
                StyledButton(
                  child: Text('historia treningów'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (HistoryRoute())),
                    );
                  },
                ),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GuestBook(
                        kcal: KCAL,
                        pace: PACE,
                        speed: SPEED,
                        distance: DISTANCE,
                        time: TIME,
                        date: DATE,
                        addMessage: (String message, kcal, pace, speed,
                                distance, time, date) =>
                            appState.addMessageToGuestBook(message, kcal, pace,
                                speed, distance, time, date),
                        messages: appState.guestBookMessages,
                        trainingList:
                            trainingList, // przekazywanie treningu do bazy danych
                      ),
                    ],
                  ),
                ),
              ]),
            )));
  }
}
