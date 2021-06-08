import 'package:flutter/material.dart';
import 'dart:core';
import 'trainingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingSummary extends StatelessWidget {
//  var

  TrainingSummary(this.trainingModel);

  final TrainingModel trainingModel;

  var endDate;
  int totalTime = 0;
  double totalDistance = 0.0;
  var listOfLocations;
  var avgSpeed; // km/h
  var avgPace; // min/km
  var kilocalories; //kcal

  var metricDistanse;
  var metricSpeed;
  var weight;
  var height;

  void getTrainingData() {
    endDate = trainingModel.endDate;
    totalTime = trainingModel.totalTime; // s
    totalDistance = trainingModel.totalDistance; // m

    avgSpeed = trainingModel.avgSpeed; // km/h
    avgPace = trainingModel.avgPace; // min/km
    kilocalories = trainingModel.kilocalories; //kcal

    getSharedPreferences();
  }

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
        // Text('Podsumowanie:', style: TextStyle(fontSize: 30)),
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

  String getNiceTimeDisplay(int totalTime) {
    // czas calkowity w min
    var time = (double.parse(totalTime.toString()) / 60).toStringAsFixed(2);
    return "czas całkowity: " + time + " m";
  }

  String getNiceDistanceDisplay(double totalDistance) {
    // dystans calkowity w km
    var distance = double.parse((totalDistance / 1000).toStringAsFixed(3));

    return "odległość:" + distance.toString() + " km";
  }

  String getNiceSpeedDisplay(double avgSpeed) {
    // predkosc srednia

    return "średnia prędkość: " + avgSpeed.toStringAsFixed(1) + " km/h";

    // return "średnia prędkość: " + 69.toString() + " km/h";
  }

  String getNicePaceDisplay(double avgPace) {
    // tempo

    return "tempo: " + avgPace.toStringAsFixed(2) + " m/km";
  }

  String getNiceCaloriesDisplay(double kilocalories) {
    // getSharedPreferences();
    // // spalone kilokalorie
    // // Kcal ~= METS * bodyMassKg * timePerformingHours
    //
    // if (weight != null && totalDistance > 0.0) {
    //   var mets = 6.0; // dla biegania
    //   double kilocalories = mets * weight * (totalTime / 3600);
    //
    //   return kilocalories.toStringAsFixed(2) + " kcal";
    // } else {
    //   return "0.0 kcal";
    // }

    return kilocalories.toStringAsFixed(2) + " kcal";

    // return "kcal";
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
////  appBar: AppBar(
////  title: const Text('Sample Code'),
////  ),
//      body: Center(
//          child: Text('Training Summary')
//      ),
//
//    )
//    ;
//  }
}
