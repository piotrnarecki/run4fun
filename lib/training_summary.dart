import 'package:flutter/material.dart';
import 'dart:core';
import 'trainingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';



// klasa odpowiedzialna za tworzenie widgetu z podsumowaniem treningu
class TrainingSummary extends StatelessWidget {
  TrainingSummary(this.trainingModel);

  final TrainingModel trainingModel;

  var endDate;//data treningu
  int totalTime = 0; //czas calkowity [s]
  double totalDistance = 0.0; //odleglosc calkowita [m]
  var listOfLocations; // lista lokalizacji
  var avgSpeed; //predkosc srednia [km/h]
  var avgPace; // tempo srednie [min/km]
  var kilocalories;  //ilosc spalonych kalorii [kcal]
  var metricDistanse;//zmienna sprawdzajaca czy podawac odleglosc w jednostch metrycznych czy imperialnych
  var metricSpeed; //zmienna sprawdzajaca czy podawac predkosc w jednostch metrycznych czy imperialnych
  var weight; //wzrost biegacza
  var height; //masa biegacza



//metoda pobieraca dane treningu
  void getTrainingData() {
    endDate = trainingModel.endDate;
    totalTime = trainingModel.totalTime; // s
    totalDistance = trainingModel.totalDistance; // m
    avgSpeed = trainingModel.avgSpeed; // km/h
    avgPace = trainingModel.avgPace; // min/km
    kilocalories = trainingModel.kilocalories; //kcal
    getSharedPreferences();
  }
// metoda pobierac jednostki, mase i wzrost biegacza
  Future<void> getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    metricDistanse = prefs.getBool('distance_settings') ?? false;
    metricSpeed = prefs.getBool('speed_settings') ?? false;
    height = prefs.getDouble('height') ?? 175;
    weight = prefs.getDouble('weight') ?? 70;
  }

  @override
  Widget build(BuildContext context) {
    getTrainingData();

    return Column(
      children: [
        Text(getNiceTimeDisplay(totalTime), style: TextStyle(fontSize: 20)),
        Text(getNiceDistanceDisplay(totalDistance),
            style: TextStyle(fontSize: 20)),
        Text(getNiceSpeedDisplay(avgSpeed), style: TextStyle(fontSize: 20)),
        Text(getNicePaceDisplay(avgPace), style: TextStyle(fontSize: 20)),
        Text(getNiceCaloriesDisplay(kilocalories),
            style: TextStyle(fontSize: 20)),
      ],
    );
  }

  //metoda zwracajaca Stringa z czasem
  String getNiceTimeDisplay(int totalTime) {
    // czas calkowity w min
    var time = (double.parse(totalTime.toString()) / 60).toStringAsFixed(2);
    return "czas całkowity: " + time + " m";
  }
//metoda zwracajaca Stringa z odlegloscia
  String getNiceDistanceDisplay(double totalDistance) {
    // dystans calkowity w km
    var distance = double.parse((totalDistance / 1000).toStringAsFixed(3));

    return "odległość:" + distance.toString() + " km";
  }
//metoda zwracajaca Stringa z predkoscia
  String getNiceSpeedDisplay(double avgSpeed) {
    // predkosc srednia

    return "średnia prędkość: " + avgSpeed.toStringAsFixed(1) + " km/h";
  }
//metoda zwracajaca Stringa z tempem
  String getNicePaceDisplay(double avgPace) {
    // tempo

    return "tempo: " + avgPace.toStringAsFixed(2) + " m/km";
  }
//metoda zwracajaca Stringa z kaloriami
  String getNiceCaloriesDisplay(double kilocalories) {
    return "spalone kalorie:" + kilocalories.toStringAsFixed(2) + " kcal";

  }
}
