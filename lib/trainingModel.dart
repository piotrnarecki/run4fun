import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrainingModel {
  double totalDistance;
  int totalTime;
  DateTime endDate;

  double avgSpeed;
  double avgPace;

  double kilocalories;

  List<LatLng> listOfLocations;

  // List <LatLng> listOfLocations;

  // Constructor, with syntactic sugar for assignment to members.
  TrainingModel(this.totalDistance, this.totalTime, this.endDate, this.avgSpeed,
      this.avgPace, this.kilocalories,this.listOfLocations) {
    // Initialization code goes here.
  }
}
