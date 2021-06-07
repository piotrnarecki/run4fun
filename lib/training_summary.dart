import 'package:flutter/material.dart';
import 'dart:core';

class TrainingSummary extends StatelessWidget {
//  var

  TrainingSummary(this.yourData);

  final List<Object> yourData;

  var endDate;
  var totalTime;
  var totalDistance;
  var listOfLocations;
  var listOfSpeed;
  var avgSpeed;
  var runningPace;

  void createTrainingSummary() {
    endDate = yourData[0].toString();
    totalTime = double.parse(yourData[1].toString());
    totalDistance = double.parse(yourData[2].toString());
    listOfLocations = yourData[3];
    listOfSpeed = yourData[4];




    // tempo
    runningPace = double.parse(
        ((totalTime / 60) / (totalDistance / 1000)).toStringAsFixed(1)); // m/km

    // predkosc srednia
    var sumOfSpeed = 0.0;
    for (var speed in listOfSpeed) {
      sumOfSpeed = sumOfSpeed + speed;
    }
    avgSpeed = double.parse(
        (sumOfSpeed * 3.6 / listOfSpeed.length).toStringAsFixed(2)); // w km/h

    // dystans calkowity w km
    totalDistance=double.parse((totalDistance/1000).toStringAsFixed(3));

    // czas calkowity w min
    totalTime=double.parse((totalTime/60).toStringAsFixed(2));

    //ladna data

  }

  @override
  Widget build(BuildContext context) {
    createTrainingSummary();

    return Column(
      children: [
        Text('Podsumowanie treningu :'),
        // Text('${yourData[0]}'),
        Text('czas: ${totalTime} m'),
        Text('dystans: ${totalDistance} km'),
        Text('średnia prędkość: ${avgSpeed} km/h'),
        Text('tempo: ${runningPace} min/km')
      ],
    );
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
