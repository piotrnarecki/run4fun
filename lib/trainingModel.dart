import 'package:google_maps_flutter/google_maps_flutter.dart';



// klasa bedaca modelem treningu
class TrainingModel {
  double totalDistance; // odleglosc calkowita treningu [m]
  int totalTime; // czas calkowity treningu [s]
  DateTime endDate; // data zakonczenia treningu HH:MM DD:MM:YYYY
  double avgSpeed; // srednia predkosc [m/s]
  double avgPace; //srednie tempo [s/m]
  double kilocalories;// spalone kalorie [kcal]
  List<LatLng> listOfLocations; // lista koordynatow podczas treningu

  TrainingModel(this.totalDistance, this.totalTime, this.endDate, this.avgSpeed,
      this.avgPace, this.kilocalories, this.listOfLocations) {}
}
