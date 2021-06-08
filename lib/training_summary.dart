import 'package:flutter/material.dart';
import 'dart:core';
import 'trainingModel.dart';

class TrainingSummary extends StatelessWidget {
//  var

  TrainingSummary(this.trainingModel);

  final TrainingModel trainingModel;

  var endDate;
  int totalTime =0;
  double totalDistance = 0.0;
  var listOfLocations;
  List<double> listOfSpeed=[];


  void getTrainingData() {
    endDate = trainingModel.endDate;
    totalTime = trainingModel.totalTime;
    totalDistance = trainingModel.totalDistance;
    // listOfLocations = trainingModel[3];
    listOfSpeed = trainingModel.listOfSpeed;

    //ladna data
  }

  @override
  Widget build(BuildContext context) {
    getTrainingData();

    return Column(
      children: [
        Text('Podsumowanie treningu :'),
        Text(getNiceTimeDisplay(totalTime)),
        Text(getNiceDistanceDisplay(totalDistance)),
        Text(getNiceSpeedDisplay(listOfSpeed)),
        Text(getNicePaceDisplay(totalTime, totalDistance))
      ],
    );
  }

  String getNiceTimeDisplay(int totalTime) {
    // czas calkowity w min
    var time = (double.parse(totalTime.toString())/60).toStringAsFixed(2);
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
