import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/training_on_map_route.dart';
import 'package:run4fun/widgets.dart';

import 'login_route.dart';

import 'dart:core';
import 'training_summary.dart';
import 'trainingModel.dart';
import 'widgets.dart';

// W TEJ KLASIE BEDZIE WYSWIETLANE PODSUMOWANIE TRENINGU I DANE BEDA PRZESYLANE DO BAZY

// TUTAJ DANE PRZESYLANE DO BAZY DANYCH

class AfterTraining extends StatelessWidget {
  // AfterTraining(List<String> trainingList) : this.trainingList = trainingList;
  // final List<String> trainingList;

  AfterTraining(TrainingModel trainingModel) : this.trainingModel = trainingModel;
  final TrainingModel trainingModel;


  List<String> trainingList = [];


  List<String> getTrainingData(TrainingModel trainingModel) {
    var endDate = trainingModel.endDate;
    var totalTime = trainingModel.totalTime; //s
    var totalDistance = trainingModel.totalDistance; //m

    var avgSpeed=trainingModel.avgSpeed;  // km/h
    var avgPace=trainingModel.avgPace;// min/km
    var kilocalories=trainingModel.kilocalories; //kcal




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
    trainingList=getTrainingData(trainingModel);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Podsumowanie'),
            ),
            body: Center(
              child: ListView(children: [
                TrainingSummary(trainingModel),

                ElevatedButton(
                  child: Text('Main route'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (LoginRoute())),
                    );
                  },
                ),

                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(width: 8),
                      GuestBook(addMessage: (String message) => appState.addMessageToGuestBook(message), messages: appState.guestBookMessages, trainingList: trainingList,
                      )
                  ]),
                ),
              ]),
            )
        )
    );
  }
}
