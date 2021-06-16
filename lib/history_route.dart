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

class HistoryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
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
                // ElevatedButton(
                //   child: Text('powrót'),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => (LoginRoute())),
                //     );
                //   },
                // ),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GuestBook2(
                        //addMessage: (String message) =>
                        //    appState.addMessageToGuestBook(message),
                        kcal: '',
                        pace: '',
                        speed: '',
                        distance: '',
                        time: '',
                        date: '',
                        addMessage: (String message, kcal, pace, speed, distance, time, date) =>
                            appState.addMessageToGuestBook(message, kcal, pace, speed, distance, time, date),
                        messages: appState.guestBookMessages,
                        // trainingList: trainingList,
                        // trainingList: ["trening","data","dystans"],
                        trainingList: [],
                      ),
                    ],
                  ),
                ),
              ]),
            )));
  }
}
