import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/trainingModel.dart';
import 'package:run4fun/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:async';
import 'login_route.dart';
import 'after_training_route.dart';
import 'trainingModel.dart';
import 'widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<GDPData> getChartData(date, distance) {
  final List<GDPData> chartData = [
    GDPData('16-06-2021', '5')
  ];
  return chartData;
}

class GDPData{
  GDPData(this.date, this.distance);
  final String date;
  final String distance;
}

class HistoryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Historia treningów'),
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
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GuestBook2(
                        kcal: '',
                        pace: '',
                        speed: '',
                        distance: '',
                        time: '',
                        date: '',
                        addMessage: (String message, kcal, pace, speed, distance, time, date) =>
                            appState.addMessageToGuestBook(message, kcal, pace, speed, distance, time, date),
                        messages: appState.guestBookMessages,
                        trainingList: [],
                      ),
                    ],
                  ),
                ),
              ]),
            )
        )
    );
  }
}
