import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:run4fun/widgets.dart';
import 'after_training_route.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:core';
import 'trainingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_route.dart';

// ta klasa odpowiedzialna za rejestrownie treningu, wyswietlanie przebiegnietego dystansu,predkosci, spalonych kalori i czasu treningu
class TrainingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Example',
      theme: ThemeData.light(),
      home: TrainingView(),
    );
  }
}

class TrainingView extends StatefulWidget {
  @override
  TrainingViewState createState() => TrainingViewState();
}

class TrainingViewState extends State<TrainingView> {
  bool metricDistanse =
      true; // czy odleglosc w jednostach metrycznych czy imperialnych
  var distanceUnits = "km"; // domyslna jednostka odleglosci
  bool metricSpeed =
      true; // czy predkosc w jednostach metrycznych czy imperialnych
  var speedUnits = "km/h"; // domyslna jednostka predkosci

  var height; // wzrost biegacza [cm]
  var weight; // masa biegacza [kg]

  var endDate; // data zakonczenia treningu

  var totalDistance; // dystans calkowity treningu [m]
  var totalTime; // czas calkowity treningu [s]
  var totalCalories; // kalorie spalone podczas treningu [kcal]
  var calories = 0.0;

  var isRunning; // zmienna sprawdzajca czy trening jest rejestrowany

  var latitude; // aktualna szerokosc geograficzna biegacza
  var longitude; // aktualna dlugosc geograficzna biegacza
  var startLatitude; //  szerokosc geograficzna do wyliczania odleglosci
  var startLongitude; //  dlugosc geograficzna do wyliczania odleglosci
  var endLatitude; //  szerokosc geograficzna do wyliczania odleglosci
  var endLongitude; //  dlugosc geograficzna do wyliczania odleglosci
  List<LatLng> listOfLocations = []; // lista lokalizacji podczas treningu
  var positions = null; // lista pozycji odczytywanych z GPS
  late StreamSubscription<Position>
      streamSubscription; // strumien dancyh o lokalizacji
  bool trackLocation =
      false; // zmienna sprawdzajaca czy rejestrowana jest lokalizacja

  var distance = 0.0; // chwilowa odleglosc [m]
  var minSpeed =
      0.2; // predkosc progowa powyzej ktorej ruch uznawany jest za bieg [m/s]
  var speed; // predkosc chwilowa [m/s]
  var listSize = 0;
  List<double> listOfSpeed = []; // lista predkosci chwilowych

  var colorOfSpeed = Colors.black; // kolor tekstu wyswietlajacego predkosc
  var colorOfButton = Colors.black; // kolor tekstu przycisku start/stop
  var buttonText; // tekst przycisku start/stop

  // metoda wywolujaca sie przy tworzeniu route'a
  @override
  initState() {
    super.initState();
    checkGps();
    getSharedPreferences();
    trackLocation = false;
    positions = null;
    isRunning = false;
    buttonText = "Start";
    listOfLocations.clear();
  }

// metoda sprawdzajaca w jakich jednostkach maja byc wyswietlanie
  Future<void> getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    metricDistanse = prefs.getBool('distance_settings') ?? true;
    metricSpeed = prefs.getBool('speed_settings') ?? true;
    height = prefs.getDouble('height') ?? 175;
    weight = prefs.getDouble('weight') ?? 70;
  }

// METODY LOKALIZACJI
// metoda rejestrujaca lokalizacje i predkosc biegacza
  startLocations() {
    if (trackLocation == false) {
      setState(() => trackLocation = true);
      streamSubscription = Geolocator.getPositionStream().listen((result) {
        final location = result;
        setState(() {
          positions = location;

          speed = num.parse(location.speed.toStringAsFixed(3));

          latitude = num.parse(location.latitude.toStringAsFixed(4));

          longitude = num.parse(location.longitude.toStringAsFixed(4));

          LatLng currentLocation = LatLng(latitude, longitude);
          listOfLocations.add(currentLocation);

          listSize = listOfLocations.length;

          var length = listOfLocations.length;

          if (listSize > 2 && speed > minSpeed) {
            colorOfSpeed = Colors.black;

            listOfSpeed.add(speed);

            if (speed > 20) {
              colorOfSpeed = Colors.blue;
            }

            distance = distance + calculateDistanse(listOfLocations);

            distance = double.parse(distance.toStringAsFixed(3));
          } else {
            colorOfSpeed = Colors.red;
          }
        });
      });

      streamSubscription.onDone(() => setState(() {
            trackLocation = false;
          }));
    }
  }

// metoda wstrzymujaca rejestracje lokalizacji i predkosci biegacza
  stopLocations() {
    if (trackLocation == true) {
      streamSubscription.cancel();
      trackLocation = false;
    }
  }

// metoda sprawzajaca czy lokalizacja jest dostepna
  checkGps() async {
    final result = await Geolocator.isLocationServiceEnabled();
    if (result == true) {
      print("Success");
    } else {
      print("Failed");
    }
  }

// metoda, ktora tworzy Stringa z odlegloscia wg. podanych jednostek
  String getNiceDistanceDisplay(distance) {
    if (distance != null) {
      if (metricDistanse) {
        if (distance < 1000) {
          return (distance).toStringAsFixed(1) + " m";
        } else {
          return (distance / 1000).toStringAsFixed(3) + " km";
        }
      } else {
        return ((distance / 1000) * 0.621371192).toStringAsFixed(2) + " mi";
      }
    } else {
      return "0.0";
    }
  }

// metoda, ktora tworzy Stringa z predkoscia wg. podanych jednostek
  String getNiceSpeedDisplay(speed) {
    if (speed != null) {
      if (metricSpeed) {
        return ((speed * 3.6).toStringAsFixed(1)) + " km/h";
      } else {
        return ((speed * 3.6) * 0.621371192).toStringAsFixed(1) + " mi/h";
      }
    } else {
      return "0.0";
    }
  }

// metoda, ktora tworzy Stringa ze spalonymi kaloriami
  String getNiceCaloriesDisplay(int seconds, distance, speed) {
    if (speed != null && distance != null) {
      calories = calories + calculateCalories(seconds, distance, speed);
      return calories.toStringAsFixed(2) + " kcal";
    } else {
      return "0.0";
    }
  }

// METODY PRZYCISKOW

  //metoda obslugujaca przycisk start/stop
  buttonPressed() {
    getSharedPreferences();
    if (isRunning == true) {
      setState(() {
        isRunning = false;
        buttonText = "Start";
        colorOfButton = Colors.green;
        stopTraining();
      });
    } else {
      setState(() {
        isRunning = true;
        buttonText = "Stop";
        colorOfButton = Colors.red;
      });
      startTraining();
    }
  }

// metoda rozpoczecia trening
  startTraining() {
    _startTimer();
    trackLocation = false;
    startLocations();
  }

  // metoda wstrzymania trening
  stopTraining() {
    getSharedPreferences();
    _stopTimer();
    trackLocation = true;
    stopLocations();
  }

// metoda zakonczenia treninigu
  endTraining(context) {
    stopTraining();

    endDate = DateTime.now();

    var totalDistance = distance;
    var totalTime = seconds;

    var avgSpeed = calculateAvgSpeed(listOfSpeed);

    var avgPace = calculateAvgPace(totalTime, totalDistance);

    if (listOfLocations.length > 0) {
      var trainingModel = TrainingModel(totalDistance, totalTime, endDate,
          avgSpeed, avgPace, calories, listOfLocations);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => (AfterTraining(trainingModel))),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => (LoginRoute())),
      );
    }
  }

// METODY OBLICZENIOWE

  // metoda wyliczajaca odleglosc pomiedzy lokalizacjami na podstawie ich koordynatow
  double calculateDistanse(List<LatLng> listOfLocations) {
    var length = listOfLocations.length;

    startLatitude = listOfLocations[length - 2].latitude;

    startLongitude = listOfLocations[length - 2].longitude;

    endLatitude = listOfLocations[length - 1].latitude;
    endLongitude = listOfLocations[length - 1].longitude;

    var distance = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    distance = double.parse(distance.toStringAsFixed(3));

    return distance;
  }

// metoda zerujaca odleglosc
  clearDistance() {
    setState(() {
      distance = 0;
      listOfLocations.clear();
    });
  }

// metoda wyliczajaca kalorie spalone w czasie treningu, przyjmuje mase i predkosc biegacza oraz czas treningu

  double calculateCalories(int time, double distance, double speed) {
    // spalone kilokalorie
    // https://golf.procon.org/met-values-for-800-activities/
    // Kcal ~= METS * bodyMassKg * timePerformingHours

    if (weight != null && speed != null && seconds != null) {
      double mets = 1.6 * speed; // dla biegania

      double kilocalories = mets * weight * (seconds / 3600) / 1000;

      return kilocalories;
    } else {
      return 0.0;
    }
  }

  // metoda wyliczajaca srednia predkosc
  double calculateAvgSpeed(List listOfSpeed) {
    var avgSpeed;
    var sumOfSpeed = 0.0;

    if (listOfSpeed.isNotEmpty) {
      for (var speed in listOfSpeed) {
        sumOfSpeed = sumOfSpeed + speed;
      }
      avgSpeed = double.parse(
          (sumOfSpeed * 3.6 / listOfSpeed.length).toStringAsFixed(2)); // w km/h
    } else {
      avgSpeed = 0.0;
    }
    return avgSpeed;
  }

  // metoda wyliczajaca srednie tempo
  double calculateAvgPace(int totalTime, double totalDistance) {
    if (totalTime > 0 && totalDistance > 0) {
      var runningPace = double.parse(((totalTime / 60) / (totalDistance / 1000))
          .toStringAsFixed(1)); // m/km

      return runningPace;
    } else {
      return 0.0;
    }
  }

// METODY TIMERA
// metoda, ktora tworzy Stringa z czasem treningu w formcie HH:MM:SS
  String getNiceTimeDisplay(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  static const oneSec = const Duration(seconds: 1);

  int seconds = 0;
  late Timer myTimer;

// metoda startujaca timer
  void _startTimer() {
    myTimer = new Timer.periodic(oneSec, (timer) {
      getSharedPreferences();
      setState(() {
        seconds = seconds + 1;
      });
    });
  }

// metoda zatrzymujaca timer
  void _stopTimer() {
    if (myTimer.isActive) {
      myTimer.cancel();
    }
    setState(() {});
  }

// INTERFACE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trening"),
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
          child: Container(
        alignment: Alignment.center,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
              getNiceTimeDisplay(seconds),
              style: TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            ),
            Text(
              getNiceDistanceDisplay(distance),
              style: TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            ),
            Text(
              getNiceSpeedDisplay(speed),
              style: TextStyle(fontSize: 50, color: colorOfSpeed),
              textAlign: TextAlign.center,
            ),
            Text(
              getNiceCaloriesDisplay(seconds, distance, speed),
              style: TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            ),
            StyledButton(
              onPressed: buttonPressed,
              child: Text(buttonText,
                  style: TextStyle(fontSize: 30, color: colorOfButton)),
            ),
            StyledButton(
              onPressed: () {
                endTraining(context);
              },
              child: Text('zakończ', style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      )),
    );
  }
}
