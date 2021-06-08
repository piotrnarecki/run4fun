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
  List<double> listOfSpeed = [];

  var metricDistanse;
  var metricSpeed;
  var weight;
  var height;

  void getTrainingData() {
    endDate = trainingModel.endDate;
    totalTime = trainingModel.totalTime;
    totalDistance = trainingModel.totalDistance;
    // listOfLocations = trainingModel[3];
    listOfSpeed = trainingModel.listOfSpeed;

    //ladna data
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
        Text(getNiceTimeDisplay(totalTime), style: TextStyle(fontSize: 30)),
        Text(getNiceDistanceDisplay(totalDistance),
            style: TextStyle(fontSize: 30)),
        Text(getNiceSpeedDisplay(listOfSpeed), style: TextStyle(fontSize: 30)),
        Text(getNicePaceDisplay(totalTime, totalDistance),
            style: TextStyle(fontSize: 30)),
        Text(getNiceCaloriesDisplay(totalTime,totalDistance), style: TextStyle(fontSize: 30)),

        Text("$weight", style: TextStyle(fontSize: 30))

      ],
    );
  }

  String getNiceTimeDisplay(int totalTime) {
    // czas calkowity w min
    var time = (double.parse(totalTime.toString()) / 60).toStringAsFixed(2);
    return time;
  }

  String getNiceDistanceDisplay(double totalDistance) {
    // dystans calkowity w km
    var distance = double.parse((totalDistance / 1000).toStringAsFixed(3));

    return distance.toString();
  }

  String getNiceSpeedDisplay(List<double> listOfSpeed) {
    // predkosc srednia
    var sumOfSpeed = 0.0;
    for (var speed in listOfSpeed) {
      sumOfSpeed = sumOfSpeed + speed;
    }
    var avgSpeed = double.parse(
        (sumOfSpeed * 3.6 / listOfSpeed.length).toStringAsFixed(2)); // w km/h

    return avgSpeed.toString();
  }

  String getNicePaceDisplay(int totalTime, double totalDistance) {
    // tempo
    var runningPace = double.parse(
        ((totalTime / 60) / (totalDistance / 1000)).toStringAsFixed(1)); // m/km

    return runningPace.toString();
  }

  String getNiceCaloriesDisplay(int totalTime,double totalDistance) {

    getSharedPreferences();
    // spalone kilokalorie
    // Kcal ~= METS * bodyMassKg * timePerformingHours

    

    if(weight!=null && totalDistance>0.0){
    var mets = 6.0; // dla biegania
    double kilocalories = mets * weight * (totalTime / 3600);

    return  kilocalories.toStringAsFixed(2)+" kcal";}else{
      return "0.0 kcal";
    }
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
