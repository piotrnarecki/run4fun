
import 'package:flutter/material.dart';
import 'dart:core';

class TrainingSummary extends StatelessWidget {
//  var

  TrainingSummary(this.yourData);

  final List<String> yourData;

//  var endDate = yourData[0];
//  var totalTime = yourData[1];
//  var totalDistance = yourData[2];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Training Summary :'),
        Text('${yourData[0]}'),
        Text('${yourData[1]} s'),
        Text('${yourData[2]} m')
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