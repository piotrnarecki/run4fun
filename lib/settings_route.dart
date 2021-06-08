import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:async';

// W TEJ KLASIE BEDZA USTAWIANE TAKIE PARAMETRY UZYTKOWNIKA JAK MASA CZY WZROST (MASA POTRZEBNA DO WYLICZNENIA SPALONYCH KALORI)

class SettingsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<SettingsRoute> {
  bool metricDistanse = true;

  var distanceUnits = " km";

  bool metricSpeed = true;

  var speedUnits = " km/h";

  // bool metricWeight = true;
  // var weightUnits = "kg";
  //
  // bool metricHeight = true;
  // var heightUnits = "m, cm";


  double heightSliderValue = 175;
  double weightSliderValue = 70;


  // var minWeight;
  // var maxWeight;
  //
  // var minHeight;
  // var maxHeight;

  void changeDistanceSettings(bool metricDistanse) {
    if (metricDistanse == true) {
      distanceUnits = "km";
    } else {
      distanceUnits = "mi";
    }

    setState(() {
      distanceUnits = distanceUnits;
    });
  }

  void changeSpeedSettings(bool metricSpeed) {
    if (metricSpeed == true) {
      speedUnits = "km/h";
    } else {
      speedUnits = "mi/h";
    }

    setState(() {
      speedUnits = speedUnits;
    });
  }

  // void changeWeightSettings(bool metricWeight) {
  //   if (metricWeight == true) {
  //     weightUnits = "kg";
  //   } else {
  //     weightUnits = "lb";
  //   }
  //
  //   setState(() {
  //     weightUnits = weightUnits;
  //   });
  // }
  //
  // void changeHeightSettings(bool metricHeight) {
  //   if (metricHeight == true) {
  //     heightUnits = "m, cm";
  //   } else {
  //     heightUnits = "ft, inch";
  //   }
  //
  //   setState(() {
  //     heightUnits = heightUnits;
  //   });
  // }

  Future<void> getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    metricDistanse = prefs.getBool('distance_settings') ?? false;
    metricSpeed = prefs.getBool('speed_settings') ?? false;
    heightSliderValue = prefs.getDouble('height') ?? 175;
    weightSliderValue = prefs.getDouble('weight') ?? 70;
  }

  Future<void> saveSettings(bool metricDistanse, bool metricSpeed,
      double height, double weight) async {
    final prefs = await SharedPreferences.getInstance();

// write
    prefs.setBool('speed_settings', metricSpeed);
    prefs.setBool('distance_settings', metricDistanse);
    prefs.setDouble('height', height);
    prefs.setDouble('weight', weight);
  }

  @override
  Widget build(BuildContext context) {
    getSharedPreferences();

    return Scaffold(
        appBar: AppBar(
          title: Text('Ustawienia'),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 10, right: 10),
            children: [
              SwitchListTile(
                title: Text("$distanceUnits"),
                value: metricDistanse,
                onChanged: (bool value) {
                  setState(() {
                    metricDistanse = value;
                    changeDistanceSettings(metricDistanse);
                    saveSettings(metricDistanse, metricSpeed, heightSliderValue,
                        weightSliderValue);
                  });
                },
                secondary: const Icon(Icons.add_road),
                // secondary: const Text("odległość "),
              ),
              SwitchListTile(
                title: Text("$speedUnits"),
                value: metricSpeed,
                onChanged: (bool value) {
                  setState(() {
                    metricSpeed = value;
                    changeSpeedSettings(metricSpeed);
                    saveSettings(metricDistanse, metricSpeed, heightSliderValue,
                        weightSliderValue);
                  });
                },
                secondary: const Icon(Icons.speed),
                // secondary: const Text("prędkość "),
              ),
              // SwitchListTile(
              //   title: Text("$weightUnits"),
              //   value: metricWeight,
              //   onChanged: (bool value) {
              //     setState(() {
              //       metricWeight = value;
              //       changeWeightSettings(metricWeight);
              //     });
              //   },
              //   secondary: const Icon(Icons.approval), // zmienic
              //   // secondary: const Text("masa        "),
              // ),
              // SwitchListTile(
              //   title: Text("$heightUnits"),
              //   value: metricHeight,
              //   onChanged: (bool value) {
              //     setState(() {
              //       metricHeight = value;
              //       changeHeightSettings(metricHeight);
              //     });
              //   },
              //   secondary: const Icon(Icons.accessibility),
              //   // secondary: const Text("wzrost       "),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Text("wzrost")),
                  Expanded(
                      flex: 8,
                      child: Slider(
                        // wzrost
                        value: heightSliderValue,
                        min: 110.0,
                        max: 230.0,
                        divisions: 120,
                        label: heightSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            heightSliderValue = value;
                            saveSettings(metricDistanse, metricSpeed,
                                heightSliderValue, weightSliderValue);
                          });
                        },
                      )),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Text("waga")),
                  Expanded(
                      flex: 8,
                      child: Slider(
                        // masa w kg

                        value: weightSliderValue,
                        min: 30.0,
                        max: 180.0,
                        divisions: 150,
                        label: weightSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            weightSliderValue = value;
                            saveSettings(metricDistanse, metricSpeed,
                                heightSliderValue, weightSliderValue);
                          });
                        },
                      )
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
