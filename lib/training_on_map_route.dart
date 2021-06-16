import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:run4fun/trainingModel.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(51.254279895398746, 15.608545592851225);
const LatLng DEST_LOCATION = LatLng(51.25183543202978, 15.615625447742124);

LatLng START_LOCATION = LatLng(0, 0);


class TrainingOnMap extends StatefulWidget {
  TrainingOnMap(TrainingModel trainingModel)
      : this.trainingModel = trainingModel;
  TrainingModel trainingModel;

  // void getTrainingModel(TrainingModel trainingModel){
  //
  //
  //   myTrainingModel=trainingModel;
  //
  // }

  @override
  State<StatefulWidget> createState() => TrainingOnMapState();
}

class TrainingOnMapState extends State<TrainingOnMap> {
  Completer<GoogleMapController> _controller = Completer();

// this set will hold my markers
  Set<Marker> _markers = {};

// this will hold the generated polylines
  Set<Polyline> _polylines = {};

// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "<AIzaSyArLbGXGnUz7MpiMe-jI0hmW77zgqUOyHw>";

// for my custom icons
//   BitmapDescriptor sourceIcon;
//   BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    // setSourceAndDestinationIcons();

    START_LOCATION=getPointsFromTraining(widget.trainingModel)[0];


  }

  // void setSourceAndDestinationIcons() async {
  //   sourceIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5),
  //       'assets/driving_pin.png');
  //   destinationIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5),
  //       'assets/destination_map_marker.png');
  // }

  @override
  Widget build(BuildContext context) {


    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: START_LOCATION); //SOURCE_LOCATION
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

  List<LatLng> getPointsFromTraining(TrainingModel trainingModel) {
    return trainingModel.listOfLocations;
  }

  // void getTrainingModel(TrainingModel trainingModel){
  //
  //
  //   myTrainingModel=trainingModel;
  // }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    var trainingModel = widget.trainingModel;
    setMapPins(getPointsFromTraining(trainingModel));
    // setPolylines();
  }

  void setMapPins(List<LatLng> listOfLocation) {
    setState(() {

      listOfLocation.forEach((location) {

        _markers.add(Marker(
          markerId: MarkerId("1"),

          position: location,
          // icon: sourceIcon
        ));

      });






      //
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: SOURCE_LOCATION,
        // icon: sourceIcon
      ));
      //

      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: DEST_LOCATION,
        // icon: destinationIcon
      ));

      // // destination pin
      // _markers.add(Marker(
      //   markerId: MarkerId('mylocation'),
      //   position: listOfLocation[listOfLocation.length],
      //   // icon: destinationIcon
      // ));
      //
      //
      // _markers.add(Marker(
      //   markerId: MarkerId('mylocation2'),
      //   position: LatLng(51.26453857578869, 15.61730245042204),
      //   // icon: destinationIcon
      // ));



    });
  }

  setPolylines() async {
    PointLatLng POINT_SOURCE_LOCATION =
        PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);
    PointLatLng POINT_DEST_LOCATION =
        PointLatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);

    List<PointLatLng> result = (await polylinePoints.getRouteBetweenCoordinates(
            googleAPIKey, POINT_SOURCE_LOCATION, POINT_DEST_LOCATION)
        as List<PointLatLng>);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }
}
