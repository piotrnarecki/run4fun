import 'package:flutter/material.dart';
import 'after_training_route.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:core';

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

  var heading;

  var listOfLocations = [];
  var listSize = 0;

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

    buttonText = "Start";
  }

//  var locationOptions = LocationOptions(
//    accuracy: LocationAccuracy.bestForNavigation,
//    distanceFilter: 0,
//    timeInterval: 0,
//  );

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

          heading = location.heading;

          listOfLocations.add(location);

          listSize = listOfLocations.length;

          var length = listOfLocations.length;

          if (length > 2 && speed > 0.5) {
            // zmienic min speed
            colorOfSpeed = Colors.black;

            if (speed > 20) {
              colorOfSpeed = Colors.blue;
            }

            distance = distance + calculateDistanse(listOfLocations);
            distance = double.parse(distance.toStringAsFixed(3));
          } else {
            //distance = 0;
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

//    var Training=

    var trainingList = [
      latitude.toString(),
      longitude.toString(),
      distance.toString(),
      speed.toString(),
      heading.toString()
    ];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (AfterTraining(trainingList))),
    );
  }

  // METODY TIMERA

  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;

  var _timeDisplay;
  static const oneSec = const Duration(seconds: 1);

  late Timer myTimer;

  void _startTimer() {
    myTimer = new Timer.periodic(oneSec, (timer) {
      _seconds = _seconds + 1;
//      totalTime = totalTime + 1;
//
//      if (_seconds == 61) {
//        _minutes = _minutes + 1;
//        _seconds = 0;
//      }
//
//      if (_minutes == 61) {
//        _hours = _hours + 1;
//        _minutes = 0;
//      }
//
//      var secondsDisplay = "$_seconds";
//      var minutesDisplay = "$_minutes";
//      var hoursDisplay = "$_hours";
//
//      if (_seconds < 10) {
//        secondsDisplay = "0" + secondsDisplay;
//      }
//      if (_minutes < 10) {
//        minutesDisplay = "0" + minutesDisplay;
//      }
//      if (_hours < 10) {
//        hoursDisplay = "0" + hoursDisplay;
//      }

      //_timeDisplay = "$hoursDisplay:$minutesDisplay:$secondsDisplay";

      setState(() {
//        _timeDisplay = "seconds";
        _seconds = _seconds;
//totalTime = totalTime;
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
        child: ListView(
          children: [
            Text(
              "${latitude} , ${longitude}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$_seconds ",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$_timeDisplay ",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$distance m",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "$listSize",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$speed m/s",
              style: TextStyle(fontSize: 30, color: colorOfSpeed),
            ),
            TextButton(
              onPressed: buttonPressed,
              onLongPress: clearDistance,
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 30, color: colorOfButton),
              ),
            ),
            TextButton(
              onPressed: () {
                endTraining(context);
              },
              child: Text(
                "end training",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
