import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'login_route.dart';

//Klasa obsługująca ścieżkę do historii pomiarów
class HistoryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Example',
      theme: ThemeData.light(),
      home: Scaffold(
        //Pasek z nazwą aktualnego ekranu
        appBar: AppBar(
        title: Text('Historia treningów'),
        actions: <Widget>[
          //Ikona do powrotu do ekranu logowania
          IconButton(
            icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => (LoginRoute())),);
                },
              )
            ],
          ),
          //Ciało ekranu, zawartość wyświetlana w historii
          body: Center(
            child: ListView(children: [
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Wywołanie klasy odpowiadającej za reprezentację danych z bazy danych
                    GuestBook2(kcal: '', pace: '', speed: '', distance: '', time: '', date: '',
                      addMessage: (String message, kcal, pace, speed, distance, time, date) =>
                          appState.addMessageToGuestBook(message, kcal, pace, speed, distance, time, date),
                      messages: appState.guestBookMessages,
                      trainingList: [],
                    ),
                  ],
                ),
              ),
            ]
          ),
        )
      )
    );
  }
}
