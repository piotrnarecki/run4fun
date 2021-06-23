import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:run4fun/trainingModel.dart';


// ta klasa odpowiedzialna za wyswietlanie treningu na mapie Google

// parametry widoku mapy
const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

//lokalizacja poczatkowa, zmienia sie razem z treningiem
LatLng SOURCE_LOCATION = LatLng(51.254279895398746, 15.608545592851225);
LatLng DEST_LOCATION = LatLng(51.25183543202978, 15.615625447742124);
LatLng START_LOCATION = LatLng(0, 0);



class TrainingOnMap extends StatefulWidget {
  TrainingOnMap(TrainingModel trainingModel)
      : this.trainingModel = trainingModel;
  TrainingModel trainingModel;
  @override
  State<StatefulWidget> createState() => TrainingOnMapState();
}

class TrainingOnMapState extends State<TrainingOnMap> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {}; // lista znacznikow na mapie
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "<AIzaSyArLbGXGnUz7MpiMe-jI0hmW77zgqUOyHw>";


// metoda dodajaca poczatkowy punkt na mape
  @override
  void initState() {
    super.initState();

    START_LOCATION = getPointsFromTraining(widget.trainingModel)[0];

  }


  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: START_LOCATION);
    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated);
  }

  // metoda zwracajaca liste koordynatow z obiektu TrainingModel
  List<LatLng> getPointsFromTraining(TrainingModel trainingModel) {
    return trainingModel.listOfLocations;
  }

  // metoda tworzaca mape
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    var trainingModel = widget.trainingModel;
    setMapPins(getPointsFromTraining(trainingModel));
    setPolylines(getPointsFromTraining(trainingModel));
  }

  //metoda nanoszaca znaczniki
  void setMapPins(List<LatLng> listOfLocation) {
    setState(() {
      var i = 0;
      listOfLocation.forEach((location) {
        print("LOKACJA: ${location.latitude} ${location.longitude} I= $i");
        _markers.add(Marker(
          markerId: MarkerId("$i"),
          position: location,
        ));
        i++;
      });


    });
  }
  //metoda nanoszaca linie
  setPolylines(List<LatLng> listOfLocation) async {
    for (var i = 0; i < listOfLocation.length - 1; i++) {
      PointLatLng POINT_SOURCE_LOCATION =
          PointLatLng(listOfLocation[i].latitude, listOfLocation[i].longitude);
      PointLatLng POINT_DEST_LOCATION = PointLatLng(
          listOfLocation[i + 1].latitude, listOfLocation[i + 1].longitude);

      print("${listOfLocation[i].latitude}");

      List<PointLatLng> result =
          (await polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey, POINT_SOURCE_LOCATION, POINT_DEST_LOCATION)
              as List<PointLatLng>);
      if (result.isNotEmpty) {

        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      _polylines.add(polyline);
    });
  }
}
