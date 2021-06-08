import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'after_training_route.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:core';
import 'trainingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_route.dart';
// W TEJ KLASIE BEDZIE TRENING

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
  bool metricDistanse = true;

  //var distanceUnits = "km";

  bool metricSpeed = true;

  //var speedUnits = "km/h";

  var height;
  var weight;

  var endDate;

  var totalDistance;
  var totalTime;
  var totalCalories;
  var calories = 0.0;

  var isRunning;

  var buttonText;

  var latitude;
  var longitude;

  var startLatitude;
  var startLongitude;

  var endLatitude;
  var endLongitude;

  var distance = 0.0;
  var minSpeed = 0.5;
  var speed;

  var listOfLocations = [];
  var listSize = 0;
  List<double> listOfSpeed = [];

  var colorOfSpeed = Colors.black;
  var colorOfButton = Colors.black;

  var positions = null;
  late StreamSubscription<Position> streamSubscription;
  bool trackLocation = false;

  @override
  initState() {
    super.initState();
    checkGps();

    getSharedPreferences();

    trackLocation = false;
    positions = null;

    isRunning = false;
    // speed=0.0;

    buttonText = "Start";
  }

  Future<void> getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    metricDistanse = prefs.getBool('distance_settings') ?? true;
    metricSpeed = prefs.getBool('speed_settings') ?? true;
    height = prefs.getDouble('height') ?? 175;
    weight = prefs.getDouble('weight') ?? 70;
  }

  // METODY LOKALIZACJI

  startLocations() {
    if (trackLocation == false) {
      setState(() => trackLocation = true);

      streamSubscription = Geolocator.getPositionStream().listen((result) {
        final location = result;

        setState(() {
          positions = location;

          speed = num.parse(location.speed.toStringAsFixed(3));

          latitude = num.parse(location.latitude.toStringAsFixed(3));

          longitude = num.parse(location.longitude.toStringAsFixed(3));

          listOfLocations.add(location);

          listSize = listOfLocations.length;

          var length = listOfLocations.length;

          if (length > 2 && speed > minSpeed) {
            // zmienic min speed
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

      streamSubscription.onDone(() =>
          setState(() {
            trackLocation = false;
          }));
    }
  }

  stopLocations() {
    if (trackLocation == true) {
      streamSubscription.cancel();
      trackLocation = false;
    }
  }

  checkGps() async {
    final result = await Geolocator.isLocationServiceEnabled();
    if (result == true) {
      print("Success");
    } else {
      print("Failed");
    }
  }

  calculateDistanse(List listOfLocations) {
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

  clearDistance() {
    setState(() {
      distance = 0;
      listOfLocations.clear();
    });
  }

  double calculateCalories(int time, double distance, double speed) {
    // spalone kilokalorie
    // https://golf.procon.org/met-values-for-800-activities/
    // Kcal ~= METS * bodyMassKg * timePerformingHours

    if (weight != null && speed != null && seconds != null) {
      double mets = 1.6 * speed; // dla biegania

      double kilocalories = mets * weight * (totalTime / 3600);

      // double kilocalories = speed * weight * totalTime;

      return kilocalories;
    } else {
      return 70.0;
    }
  }

  getNiceDistanceDisplay(double distance) {
    if (distance != Null) {
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

  getNiceSpeedDisplay(double speed) {
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

  String getNiceCaloriesDisplay(int seconds, double distance, double speed) {
    calories = calories + calculateCalories(seconds, distance, speed);
    return calories.toStringAsFixed(2) + " kcal";
  }

// METODY PRZYCISKOW

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

  startTraining() {
    _startTimer();
    trackLocation = false;
    startLocations();
  }

  stopTraining() {
    getSharedPreferences();
    _stopTimer();
    trackLocation = true;
    stopLocations();
  }

  endTraining(context) {
    stopTraining();

    endDate = DateTime.now();

    var totalDistance = distance;
    // var totalTime = double.parse(seconds.toString());
    var totalTime = seconds;

    // var trainingList = [
    //   endDate.toString(),
    //   totalTime.toString(),
    //   totalDistance.toString(),
    // ];

    var avgSpeed = calculateAvgSpeed(listOfSpeed);

    var avgPace = calculateAvgPace(totalTime, totalDistance);

    var kilocalories = 1000.0;
    var trainingModel = TrainingModel(totalDistance, totalTime, endDate,
        avgSpeed, avgPace, kilocalories); // srednia predkosc

    // var trainingList = [
    //   latitude.toString(),
    //   longitude.toString(),
    //   distance.toString(),
    //   speed.toString(),
    // ];

// tutaj dodaj do bazy

    Navigator.push(
      context,
      // MaterialPageRoute(builder: (context) => (AfterTraining(trainingList))),
      MaterialPageRoute(builder: (context) => (AfterTraining(trainingModel))),
    );
  }

// METODY OBLICZENIOWE

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

  void _startTimer() {
    myTimer = new Timer.periodic(oneSec, (timer) {
      getSharedPreferences(); // sprawdzic
      setState(() {
        seconds = seconds + 1;

        // calories = calories + calculateCalories(seconds, distance, speed);

        // calories = calories + 10;
      });
    });
  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.flag_outlined),
            onPressed: () {
              endTraining(context);
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
                  "w: $weight, h: $height",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
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
                // Text(
                //   getNiceCaloriesDisplay(seconds, distance, speed),
                //   style: TextStyle(fontSize: 50),
                //   textAlign: TextAlign.center,
                // ),
                TextButton(
                  onPressed: buttonPressed,
                  onLongPress: clearDistance,
                  child: Text(
                    buttonText,
                    style: TextStyle(fontSize: 50, color: colorOfButton),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    endTraining(context);
                  },
                  child: Text(
                    "end training",
                    style: TextStyle(fontSize: 50, color: Colors.black),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
