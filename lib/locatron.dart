import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';
import 'globalVariables.dart' as globals;


var isPressed = false;

var positions = null;
late StreamSubscription<Position> streamSubscription;
bool trackLocation = false;


class Locatron {


  var latitude;
  var longitude;
  var speed;


  var listOfLocations;

  Locatron({
    this.latitude,
    this.longitude,
    this.speed,
  });



  startLocationStream() {
    if (trackLocation) {
      streamSubscription.cancel();
      positions = null;
    } else {
      streamSubscription = Geolocator.getPositionStream().listen((result) {
        final location = result;


        positions = location;


        latitude = num.parse(location.latitude.toStringAsFixed(3));

        longitude = num.parse(location.longitude.toStringAsFixed(3));


        globals.currentLatitude=latitude;
//        globals.currentLongitude=longitude;

print("LOCATION $latitude");

        //listOfLocations.add(location);
      }
      );
    };

    streamSubscription.onDone(() =>
    (() {
      trackLocation = false;
    }));



  }




stopLocationStream() {

  streamSubscription.cancel();

}


calculateDistance() {


}

}