import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'after_training_route.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:core';
import 'trainingModel.dart';
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
  var endDate;

  var totalDistance;
  var totalTime;

  var isRunning;

  var buttonText;

  var latitude;
  var longitude;

  var startLatitude;
  var startLongitude;

  var endLatitude;
  var endLongitude;

  var distance = 0.0;
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

    trackLocation = false;
    positions = null;

    isRunning = false;
    // speed=0.0;

    buttonText = "Start";
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

          if (length > 2 && speed > 0.5) {
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

  getNiceDistanceDisplay(double distance) {
    if (distance != Null) {
      return distance.toString();
    } else {
      return "0.0";
    }
  }

  getNiceSpeedDisplay(double speed) {
    if (distance != Null) {
      return speed.toString();
    } else {
      return "0.0";
    }
  }

  // METODY PRZYCISKOW

  buttonPressed() {
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
    //   listOfLocations,
    //   listOfSpeed
    // ];

    var trainingModel =
        TrainingModel(totalDistance, totalTime, endDate, listOfSpeed);

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
      setState(() {
        seconds = seconds + 1;
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
//        actions: <Widget>[
////          FlatButton(
////            child: Text("Get Location"),
////            onPressed: getLocations,
////          )
//        ],
          ),
      body: Center(
          child: Container(
        alignment: Alignment.center,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [

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
