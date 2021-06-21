import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'after_training_route.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:core';
import 'trainingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_route.dart';
import 'login_route.dart';
// W TEJ KLASIE BEDZIE TRENING

class TrainingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Example',
      theme: ThemeData.light(),
      // theme: ThemeData(
      //   buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     highlightColor: Colors.deepPurple,
      //   ),
      //   primarySwatch: Colors.orange,
      //   textTheme: GoogleFonts.robotoTextTheme(
      //     Theme.of(context).textTheme,
      //   ),
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),

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

  var distanceUnits = "km";

  bool metricSpeed = true;

  var speedUnits = "km/h";

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

  List<LatLng> listOfLocations = [];

  var distance = 0.0;
  var minSpeed = 0.2; // 0.5
  var speed;

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

    listOfLocations.clear();
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

          latitude = num.parse(location.latitude.toStringAsFixed(4));

          longitude = num.parse(location.longitude.toStringAsFixed(4));

          LatLng currentLocation = LatLng(latitude, longitude);
          listOfLocations.add(currentLocation);

          listSize = listOfLocations.length;

          var length = listOfLocations.length;

          if (listSize > 2 && speed > minSpeed) {
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

      streamSubscription.onDone(() => setState(() {
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

      double kilocalories = mets * weight * (seconds / 3600) / 1000;

      // double kilocalories = speed * weight * totalTime;

      return kilocalories;
    } else {
      return 0.0;
    }
  }

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

  String getNiceCaloriesDisplay(int seconds, distance, speed) {
    if (speed != null && distance != null) {
      calories = calories + calculateCalories(seconds, distance, speed);
      return calories.toStringAsFixed(2) + " kcal";
    }
    else{
      return "0.0";
    }
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

    // var kilocalories = 1000.0;

    if (listOfLocations.length > 0) {
      var trainingModel = TrainingModel(totalDistance, totalTime, endDate,
          avgSpeed, avgPace, calories, listOfLocations); // srednia predkosc

      Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => (AfterTraining(trainingList))),
        MaterialPageRoute(builder: (context) => (AfterTraining(trainingModel))),
      );
    } else {
      Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => (AfterTraining(trainingList))),
        MaterialPageRoute(builder: (context) => (LoginRoute())),
      );
    }
    // var trainingList = [
    //   latitude.toString(),
    //   longitude.toString(),
    //   distance.toString(),
    //   speed.toString(),
    // ];

// tutaj dodaj do bazy
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
                        "zakończ",
                        style: TextStyle(fontSize: 50, color: Colors.black),
                      ),
                    ),
                  ],
                ),
      )),
    );
  }
}
