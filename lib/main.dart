import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/login_route.dart';
import 'settings_route.dart';
import 'training_route.dart';

void main() {

  // tutaj metoda sprawdzająca czy użytkownik jest zalogowany

  // metoda wyswietlanjaca imię i statystki użytkownika

  runApp(
      ChangeNotifierProvider(
          create: (context) => ApplicationState(),
        child: MaterialApp(
          title: 'Navigation Basics',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: MainRoute(),
        )
      ),
  );
}


// W TEJ KLASIE BEDZIE WYSWIETLANY GLOWNY EKRAN Ekran

class MainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run 4 Fun'),
      ),
      body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Text('Training'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => (TrainingRoute())),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Login'), // ten przycisk nie działa !!!
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => (LoginRoute())),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Settings'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => (SettingsRoute())),
              );
            },
          ),
        ],
      )),
    );
  }
}
