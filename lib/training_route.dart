import 'package:flutter/material.dart';

import 'settings_route.dart';
import 'training_route.dart';
import 'main.dart';
import 'after_training_route.dart';

import 'package:geolocator/geolocator.dart';

import 'dart:async';


// W TEJ KLASIE BEDZIE TRENING



class TrainingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Example',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  var isPressed;

  var buttonText;

  var latitude;
  var longitude;

  var startLatitude;

  var startLongitude;

  var endLatitude;

  var endLongitude;

  var distance;

  var speed;
  var heading;

  var listOfLocations = [];
  var listSize = 0;

  var colorOfSpeed = Colors.white;

  var colorOfButton = Colors.white;

  Position positions = null;
  StreamSubscription<Position> streamSubscription;
  bool trackLocation = false;

  @override
  initState() {
    super.initState();
    checkGps();

    trackLocation = false;
    positions = null;

    isPressed = false;

    buttonText = "Start";
  }

  buttonOnPressed() {
    setState(() {
      if (isPressed == true) {
        buttonText = "Start";
        isPressed = false;
        colorOfButton = Colors.green;
      } else {
        buttonText = "Stop";
        isPressed = true;
        colorOfButton = Colors.red;
      }
    });

    getLocations();
  }

  var locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
    timeInterval: 0,
  );

  getLocations() {
    if (trackLocation) {
      setState(() => trackLocation = false);
      streamSubscription.cancel();
      streamSubscription = null;
      positions = null;
    } else {
      setState(() => trackLocation = true);

      streamSubscription = Geolocator.getPositionStream().listen((result) {
        final location = result;

        setState(() {
          positions = location;

          speed = num.parse(location.speed.toStringAsFixed(3));

          heading = num.parse(location.heading.toStringAsFixed(0));

          latitude = num.parse(location.latitude.toStringAsFixed(3));

          longitude = num.parse(location.longitude.toStringAsFixed(3));

          listOfLocations.add(location);

          listSize = listOfLocations.length;

          var length = listOfLocations.length;

          if (length > 2 && speed > 1) {
            colorOfSpeed = Colors.white;

            if (speed > 20) {
              colorOfSpeed = Colors.blue;
            }

            distance = distance + calculateDistanse(listOfLocations);
            distance = num.parse(distance.toStringAsFixed(3));
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

    distance = num.parse(distance.toStringAsFixed(3));

    return distance;
  }

  clearDistance() {
    setState(() {
      distance = 0;
      listOfLocations.clear();
    });
  }

  endTraining(context) {



    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (AfterTraining())),
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('I am here'),
        actions: <Widget>[
//          FlatButton(
//            child: Text("Get Location"),
//            onPressed: getLocations,
//          )
        ],
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
              onPressed: buttonOnPressed,
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
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
